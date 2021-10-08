locals {
  route53_record_name = var.route53_record_name != "" ? var.route53_record_name : "cardano-node"
}

data "aws_route53_zone" "this" {
  count   = var.create_route53_record ? 1 : 0
  zone_id = var.route53_zone_id
}

resource "aws_route53_record" "this" {
  count   = var.create_route53_record && var.route53_record_name != "" ? 1 : 0
  zone_id = var.route53_zone_id
  name    = "${local.route53_record_name}.${join("", data.aws_route53_zone.this[*].name)}"
  type    = "A"
  ttl     = "300"
  #checkov:skip=CKV2_AWS_23:Record is pointing to EC2 private IP
  records = [var.ip_address]
}
