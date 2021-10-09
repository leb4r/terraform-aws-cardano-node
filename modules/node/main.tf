module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.2.0"

  name         = var.name
  description  = "Security Group for ${var.name}"
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

resource "aws_iam_instance_profile" "cardano_node" {
  name_prefix = "${var.name}-profile-"
  role        = var.iam_role_name
  tags        = var.tags
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn-ami-*-gp2"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "2.19.0"

  name                        = var.name
  ami                         = data.aws_ami.amazon_linux.id
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [module.security_group.security_group_id]
  monitoring                  = var.enable_monitoring
  ebs_optimized               = var.ebs_optimized
  user_data_base64            = base64encode(var.userdata)
  associate_public_ip_address = var.associate_public_ip_address
  instance_type               = var.instance_type
  iam_instance_profile        = aws_iam_instance_profile.cardano_node.name

  root_block_device = [
    {
      volume_type = "gp2",
      volume_size = var.root_volume_size
      encrypted   = true
      kms_key_id  = var.kms_key_arn
    }
  ]

  tags = var.tags
}
