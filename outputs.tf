output "config_bucket_name" {
  description = "Name of S3 bucket used to storage config"
  value       = module.config_bucket.s3_bucket_id
}

output "data_volume_id" {
  description = "ID of EBS volume used for data storage"
  value       = aws_ebs_volume.this.id
}

output "iam_role_name" {
  description = "IAM role name"
  value       = aws_iam_role.cardano_node.name
}

output "instance_id" {
  description = "EC2 Instance ID"
  value       = module.ec2_instance.id[0]
}

output "security_group_id" {
  description = "Security Group ID"
  value       = module.security_group.security_group_id
}
