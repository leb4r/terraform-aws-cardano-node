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

variable "kms_key_arn" {
  description = "The ARN of the KMS CMK to use for encryption"
  type        = string
}
