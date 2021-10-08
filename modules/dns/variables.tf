variable "create_route53_record" {
  description = "Set to `true` to create an A record in Route 53 for the EC2 instance"
  type        = bool
  default     = false
}

variable "route53_zone_id" {
  description = "ID of the Route 53 Zone to create record in"
  type        = string
  default     = ""
}

variable "route53_record_name" {
  description = "Name of the record to create"
  type        = string
  default     = ""
}

variable "ip_address" {
  description = "The IP address to use as the value of the A record"
  type        = string
}
