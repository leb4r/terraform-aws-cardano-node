output "block_producer_ids" {
  description = "List of EC2 instance IDs of the block producing nodes"
  value       = module.block_producer[*].instance_id
}

output "kms_key_id" {
  description = "ID of KMS CMK used for encryption-at-rest"
  value       = module.encryption_key.key_id
}

output "relay_ids" {
  description = "List of instance IDs of the relay nodes"
  value       = module.relay_node[*].instance_id
}

output "vpc_id" {
  description = "ID of VPC"
  value       = module.vpc.vpc_id
}
