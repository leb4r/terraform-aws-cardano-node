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
