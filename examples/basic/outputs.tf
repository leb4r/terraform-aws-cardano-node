output "config_bucket_name" {
  description = "Name of S3 bucket used to storage config"
  value       = module.cardano_node.config_bucket_name
}

output "data_volume_id" {
  description = "ID of EBS volume used for data storage"
  value       = module.cardano_node.data_volume_id
}

output "iam_role_name" {
  description = "IAM role name"
  value       = module.cardano_node.iam_role_name
}

output "security_group_id" {
  description = "Security Group ID"
  value       = module.cardano_node.security_group_id
}
