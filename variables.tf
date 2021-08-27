## resource placement

variable "vpc_id" {
  description = "ID of VPC to deploy node in"
  type        = string
}

variable "subnet_id" {
  description = "ID off Subnet to deploy node in"
  type        = string
}

variable "create_route53_record" {
  description = "Set to `true` to create an A record in Route 53 for the EC2 instance"
  type        = bool
  default     = false
}

variable "route53_zone_id" {
  description = "ID of the Route 53 Zone to create record in"
  type        = string
  default     = ""
}

variable "route53_record_name" {
  description = "Name of the record to create"
  type        = string
  default     = ""
}

# encryption

variable "create_kms_key" {
  description = "Set to `false` to use separate KMS key"
  type        = bool
  default     = true
}

variable "kms_key_arn" {
  description = "The ARN of the KMS CMK to use for Encryption"
  type        = string
  default     = ""
}

# instance configuration

variable "enable_monitoring" {
  description = "Whether to enable detailed monitoring for the node"
  type        = bool
  default     = true
}

variable "ebs_optimized" {
  description = "Whether the EC2 instance is EBS optimized"
  type        = bool
  default     = true
}

variable "associate_public_ip_address" {
  description = "Whether to associate a public IPv4 address for the node"
  type        = bool
  default     = false
}

variable "instance_type" {
  description = "The type of instance to use for the node"
  type        = string
  default     = "t3.large"
}

variable "tags" {
  description = "Map of tags to apply to resources"
  type        = map(string)
  default     = {}
}

variable "root_volume_size" {
  description = "Size of root volume of the node"
  type        = number
  default     = 8
}

variable "data_volume_size" {
  description = "Size of data volume of the node"
  type        = number
  default     = 30
}

## cardano node configuration

variable "cardano_node_image" {
  description = "Container image to use for the node"
  type        = string
  default     = "docker.io/inputoutput/cardano-node"
}

variable "cardano_node_version" {
  description = "Version of cardano-node to run"
  type        = string
  default     = "1.29.0"
}

variable "cardano_node_port" {
  description = "The port to listen for communication on"
  type        = number
  default     = 3001
}

variable "cardano_network" {
  description = "The cardano network to connect to, (e.g. `mainnet` or `testnet`)"
  type        = string
  default     = "mainnet"
}

variable "cardano_topology_json" {
  description = "JSON string to be used as topology config"
  type        = string
  default     = ""
}

## prometheus monitorig

variable "prometheus_ingress_cidrs" {
  description = "Comma-delimited list of CIDR blocks from which to allow Prometheus traffic on"
  type        = string
  default     = "0.0.0.0/0"
}

## backups

variable "backup_schedule" {
  description = "A CRON expression specifying when AWS Backup initiates a backup job"
  type        = string
  default     = "cron(0 12 * * ? *)"
}

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
