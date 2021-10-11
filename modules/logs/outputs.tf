output "log_group_name" {
  description = "Name of the CloudWatch Log Group that was created"
  value       = aws_cloudwatch_log_group.this.name
}

output "log_group_arn" {
  description = "ARN of the CloudWatch Log Group that was created"
  value       = aws_cloudwatch_log_group.this.arn
}
