data "aws_subnet" "this" {
  id = var.subnet_id
}

data "aws_route53_zone" "this" {
  count   = var.create_route53_record ? 1 : 0
  zone_id = var.route53_zone_id
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
