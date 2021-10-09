## config

variable "cardano_node_image" {
  description = "Container image to use for the node"
  type        = string
  default     = "docker.io/inputoutput/cardano-node"
}

variable "cardano_node_version" {
  description = "Version of cardano-node to run"
  type        = string
  default     = "1.30.1"
}

variable "cardano_node_port" {
  description = "The port to listen for communication on"
  type        = number
  default     = 3001
}

variable "cardano_node_network" {
  description = "The cardano network to connect to, (e.g. `mainnet` or `testnet`)"
  type        = string
  default     = "mainnet"
}

variable "cardano_node_topology_json" {
  description = "JSON string to be used as topology config"
  type        = string
  default     = ""
}

## resources

variable "name" {
  description = "Canocial name to give to resources"
  type        = string
  default     = "cardano-node"
}

variable "tags" {
  description = "Map of tags to pass to resources"
  type        = map(string)
  default     = {}
}

variable "kms_key_arn" {
  description = "The ARN of the KMS CMK to use for encryption"
  type        = string
}

variable "storage_volume_id" {
  description = "ID of EBS volume that is used for storage, used in userdata"
  type        = string
}
