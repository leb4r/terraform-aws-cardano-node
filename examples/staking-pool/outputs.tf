output "block_producer_ids" {
  description = "List of EC2 instance IDs of the block producing nodes"
  value       = module.block_producer[*].id
}

output "kms_key_arn" {
  description = "ARN of KMS CMK used for encryption"
  value       = module.encryption_key.key_arn
}

output "relay_ids" {
  description = "List of instance IDs of the relay nodes"
  value       = module.relay_node[*].id
}

output "vpc_id" {
  description = "ID of VPC"
  value       = module.vpc.vpc_id
}
