output "backup_vault_id" {
  description = "ID of backup vault managed by this module"
  value       = module.backup.backup_vault_id
}

output "backup_vault_arn" {
  description = "ARN of the backup vault managed by this module"
  value       = module.backup.backup_vault_arn
}
