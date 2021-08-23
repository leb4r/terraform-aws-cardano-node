module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.2.0"

  name         = "cardano-node"
  description  = "Security Group for Cardano Node"
  vpc_id       = var.vpc_id
  egress_rules = ["all-all"]

  ingress_with_cidr_blocks = [
    {
      description = "Allow Prometheus traffic"
      from_port   = 12798
      to_port     = 12798
      protocol    = "tcp"
      cidr_blocks = var.prometheus_ingress_cidrs
    }
  ]

  tags = var.tags
}

locals {
  data_volume_device_name = "/dev/sdh"
}

data "cloudinit_config" "user_data" {
  gzip          = false
  base64_encode = false

  part {
    content_type = "text/x-shellscript"
    filename     = "user-data.sh"

    content = templatefile("${path.module}/templates/user-data.sh.tpl", {
      cardano_network      = var.cardano_network,
      cardano_node_image   = var.cardano_node_image,
      cardano_node_version = var.cardano_node_version,
      config_bucket_name   = module.config_bucket.s3_bucket_id,
      ebs_volume_id        = aws_ebs_volume.this.id
    })
  }
}

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "2.19.0"

  name                        = "cardano-node"
  ami                         = data.aws_ami.amazon_linux.id
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [module.security_group.security_group_id]
  monitoring                  = var.enable_monitoring
  ebs_optimized               = var.ebs_optimized
  user_data_base64            = base64encode(data.cloudinit_config.user_data.rendered)
  associate_public_ip_address = var.associate_public_ip_address
  instance_type               = var.instance_type
  iam_instance_profile        = aws_iam_instance_profile.cardano_node.name

  root_block_device = [
    {
      volume_type = "gp2",
      volume_size = var.root_volume_size
      encrypted   = true
      kms_key_id  = var.create_kms_key ? module.encryption_key.key_arn : var.kms_key_arn
    }
  ]

  depends_on = [
    aws_s3_bucket_object.compose,
    aws_s3_bucket_object.topology
  ]

  tags = var.tags
}
