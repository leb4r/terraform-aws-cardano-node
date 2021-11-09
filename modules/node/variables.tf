variable "associate_public_ip_address" {
  description = "Set to `false` to only create allocate a private IP address for the node"
  type        = bool
  default     = true
}

variable "config_bucket_name" {
  description = "Name of S3 bucket to sync config from"
  type        = string
}

variable "ebs_optimized" {
  description = "Set to `false` is disable EBS optimized feature"
  type        = bool
  default     = true
}

variable "enable_monitoring" {
  description = "Set to `false` to disable enhanced monitoring for node"
  type        = bool
  default     = true
}

variable "iam_instance_profile_name" {
  description = "Name of the IAM instance profile to attach to the node"
  type        = string
}

variable "instance_type" {
  description = "The type of instance to use for the node"
  type        = string
  default     = "t3.large"
}

variable "kms_key_arn" {
  description = "The ARN of the KMS CMK to use for encryption"
  type        = string
}

variable "name" {
  description = "Canocial name to give to resources"
  type        = string
  default     = "cardano-node"
}

variable "prometheus_ingress_cidrs" {
  description = "Comma-delimited list of CIDR blocks from which to allow Prometheus traffic on"
  type        = string
  default     = "0.0.0.0/0"
}

variable "root_volume_size" {
  description = "Size of root volume of the node"
  type        = number
  default     = 8
}

variable "subnet_id" {
  description = "ID of Subnet to deploy node in"
  type        = string
}

variable "storage_volume_id" {
  description = "ID of an EBS volume specifically for storage"
  type        = string
}

variable "tags" {
  description = "Map of tags to apply to resources"
  type        = map(string)
  default     = {}
}

variable "vpc_id" {
  description = "ID of VPC to deploy node in"
  type        = string
}
