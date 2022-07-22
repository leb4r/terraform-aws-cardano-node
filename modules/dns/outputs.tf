output "fqdn" {
  description = "Fully Qualified Domain Name"
  value       = join("", aws_route53_record.this[*].fqdn)
}
