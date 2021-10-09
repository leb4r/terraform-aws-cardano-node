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

variable "retention_in_days" {
  description = "The number of days to keep logs in the Log Group"
  type        = number
  default     = 30
}

variable "kms_key_arn" {
  description = "The ARN of the KMS CMK to use for encryption"
  type        = string
}
