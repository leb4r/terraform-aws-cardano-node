module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.8.0"

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

data "aws_subnet" "this" {
  id = var.subnet_id
}

resource "aws_ebs_volume" "this" {
  #checkov:skip=CKV2_AWS_9:EBS volume is being passed to backup module
  availability_zone = data.aws_subnet.this.availability_zone
  size              = var.data_volume_size
  encrypted         = true
  kms_key_id        = var.kms_key_arn
  tags              = var.tags
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

locals {
  root_block_device_name = tolist(data.aws_ami.amazon_linux.block_device_mappings)[0].device_name
  data_block_device_name = "/dev/sdh"
}

data "cloudinit_config" "user_data" {
  gzip          = false
  base64_encode = false

  part {
    content_type = "text/x-shellscript"
    filename     = "user-data.sh"

    content = templatefile("${path.module}/templates/user-data.sh.tpl", {
      config_bucket_name     = var.config_bucket_name
      data_block_device_name = local.data_block_device_name
    })
  }
}

resource "aws_launch_template" "this" {
  name_prefix            = "${var.name}-lt-"
  ebs_optimized          = var.ebs_optimized
  image_id               = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  update_default_version = true
  user_data              = base64encode(data.cloudinit_config.user_data.rendered)
  tags                   = var.tags

  block_device_mappings {
    device_name = local.root_block_device_name

    ebs {
      volume_type = "gp3"
      volume_size = var.root_volume_size
      encrypted   = true
      kms_key_id  = var.kms_key_arn
    }
  }

  iam_instance_profile {
    name = var.iam_instance_profile_name
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
  version = "3.4.0"
  name    = var.name
  tags    = var.tags

  # these override the launch template, so explicitly set them to the same value
  iam_instance_profile = var.iam_instance_profile_name
  instance_type        = var.instance_type
  user_data_base64     = base64encode(data.cloudinit_config.user_data.rendered)

  launch_template = {
    name = aws_launch_template.this.name
  }
}

resource "aws_volume_attachment" "this" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.this.id
  instance_id = module.ec2_instance.id
}
