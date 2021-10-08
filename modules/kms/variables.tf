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

variable "create_kms_key" {
  description = "Set to `false` to disable creation of KMS key"
  type        = bool
  default     = true
}
