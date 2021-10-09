output "key_arn" {
  description = "ARN of KMS key created"
  value       = var.create_kms_key ? module.key.key_arn : ""
}
