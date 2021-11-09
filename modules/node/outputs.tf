output "arn" {
  description = "ARN of the EC2 instance that was created"
  value       = module.ec2_instance.arn
}

output "security_group_id" {
  description = "ID of the Security Group that was created"
  value       = module.security_group.security_group_id
}

output "id" {
  description = "ID of the EC2 instance that was created"
  value       = module.ec2_instance.id
}

output "private_ip_address" {
  description = "Private IPv4 address of the EC2 instance"
  value       = module.ec2_instance.private_ip
}

output "data_volume_id" {
  description = "ID of the EBS volume created for data storage"
  value       = aws_ebs_volume.this.id
}
