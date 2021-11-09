module "backup" {
  source  = "cloudposse/backup/aws"
  version = "0.9.0"

  name               = "${var.name}-backup"
  backup_resources   = var.backup_resources
  schedule           = var.backup_schedule
  start_window       = 60
  completion_window  = 120
  cold_storage_after = var.backup_cold_storage_after
  kms_key_arn        = var.kms_key_arn
  delete_after       = var.backup_delete_after
}
