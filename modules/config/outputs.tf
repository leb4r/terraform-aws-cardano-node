output "bucket_arn" {
  description = "ARN of S3 bucket created"
  value       = module.config_bucket.s3_bucket_arn
}

output "bucket_name" {
  description = "Name of S3 bucket created"
  value       = module.config_bucket.s3_bucket_id
}
