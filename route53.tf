locals {
  route53_record_name = var.route53_record_name != "" ? var.route53_record_name : "cardano-node"
}

resource "aws_route53_record" "this" {
  count   = var.create_route53_record && var.route53_record_name != "" ? 1 : 0
  zone_id = var.route53_zone_id
  name    = "${local.route53_record_name}.${join("", data.aws_route53_zone.this[*].name)}"
  type    = "A"
  ttl     = "300"
  records = [module.ec2_instance.private_ip[0]]
}
