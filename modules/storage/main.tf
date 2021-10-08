resource "aws_ebs_volume" "this" {
  #checkov:skip=CKV2_AWS_9:EBS volume is being passed to backup module
  availability_zone = var.availability_zone
  size              = var.volume_size
  encrypted         = true
  kms_key_id        = var.kms_key_arn
  tags              = var.tags
}

module "backup" {
  source  = "cloudposse/backup/aws"
  version = "0.9.0"

  name               = "cardano-node-backup"
  backup_resources   = [aws_ebs_volume.this.arn]
  schedule           = var.backup_schedule
  start_window       = 60
  completion_window  = 120
  cold_storage_after = var.backup_cold_storage_after
  delete_after       = var.backup_delete_after
}
