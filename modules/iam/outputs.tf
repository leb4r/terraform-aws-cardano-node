output "role_name" {
  description = "Name of IAM role created"
  value       = aws_iam_role.cardano_node.name
}
