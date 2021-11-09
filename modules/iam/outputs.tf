output "instance_profile_name" {
  description = "Name of the IAM instance profile created"
  value       = aws_iam_instance_profile.cardano_node.name
}

output "role_name" {
  description = "Name of IAM role created"
  value       = aws_iam_role.cardano_node.name
}
