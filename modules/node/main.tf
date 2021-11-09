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

data "cloudinit_config" "user_data" {
  gzip          = false
  base64_encode = false

  part {
    content_type = "text/x-shellscript"
    filename     = "user-data.sh"

    content = templatefile("${path.module}/templates/user-data.sh.tpl", {
      config_bucket_name = var.config_bucket_name
      ebs_volume_id      = var.storage_volume_id
    })
  }
}

resource "aws_launch_template" "this" {
  name_prefix   = "${var.name}-lt-"
  ebs_optimized = var.ebs_optimized
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  user_data     = base64encode(data.cloudinit_config.user_data.rendered)
  tags          = var.tags

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_type = "gp3"
      volume_size = var.root_volume_size
      encrypted   = true
      kms_key_id  = var.kms_key_arn
    }
  }

  iam_instance_profile {
    name = aws_iam_instance_profile.cardano_node.name
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }

  monitoring {
    enabled = var.enable_monitoring
  }

  network_interfaces {
    associate_public_ip_address = var.associate_public_ip_address
    subnet_id                   = var.subnet_id
    security_groups             = [module.security_group.security_group_id]
  }
}

module "ec2_instance" {
  #checkov:skip=CKV_AWS_79:this is explicitly set in the launch template
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "3.2.0"
  name    = var.name
  tags    = var.tags

  launch_template = {
    name = aws_launch_template.this.name
  }
}
