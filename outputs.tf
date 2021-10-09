output "config_bucket_name" {
  description = "Name of S3 bucket used to store config"
  value       = module.config.bucket_name
}

output "data_volume_id" {
  description = "ID of EBS volume used for data storage"
  value       = module.storage.id
}

output "iam_role_name" {
  description = "Name of IAM role used by the EC2 instance"
  value       = module.iam.role_name
}

output "security_group_id" {
  description = "ID of the Security Group used by EC2 instance"
  value       = module.node.security_group_id
}

output "instance_id" {
  description = "ID of the EC2 instance where cardano-node is runner"
  value       = module.node.id
}

output "dns_fqdn" {
  description = "FQDN of the node"
  value       = module.dns.fqdn
}
