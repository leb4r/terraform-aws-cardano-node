variable "name" {
  description = "Canocial name to give to resources"
  type        = string
  default     = "cardano-node"
}

variable "tags" {
  description = "Map of tags to apply to resources"
  type        = map(string)
  default     = {}
}

variable "config_bucket_arn" {
  description = "The ARN of the S3 bucket used to store config"
  type        = string
}

variable "kms_key_arn" {
  description = "The ARN of the KMS CMK to use for encryption"
  type        = string
}

variable "log_group_arn" {
  description = "The ARN of the CloudWatch Log Group"
  type        = string
}

variable "ssm_managed" {
  description = "Set to `false` to disable SSM access"
  type        = bool
  default     = true
}
