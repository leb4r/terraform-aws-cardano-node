variable "backup_cold_storage_after" {
  description = "Specifies the number of days after creation that a recovery point is moved to cold storage"
  type        = number
  default     = 30
}

variable "backup_delete_after" {
  description = "Specifies the number of days after creation that a recovery point is deleted. Must be 90 days greater than `cold_storage_after`"
  type        = number
  default     = 180
}

variable "backup_resources" {
  description = "Resources that are apart of the backup plan"
  type        = list(string)
  default     = []
}

variable "backup_schedule" {
  description = "A CRON expression specifying when AWS Backup initiates a backup job"
  type        = string
  default     = "cron(0 12 * * ? *)"
}

variable "kms_key_arn" {
  description = "The ARN of the KMS CMK to use for encryption"
  type        = string
}

variable "name" {
  description = "Canonical name to give backup resources"
  type        = string
  default     = "cardano-node"
}
