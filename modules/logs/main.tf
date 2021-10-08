resource "aws_cloudwatch_log_group" "this" {
  name_prefix = "${var.name}-logs-"
  kms_key_id  = var.kms_key_arn
  tags        = var.tags
}
