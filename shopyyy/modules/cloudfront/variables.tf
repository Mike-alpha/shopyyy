variable "name" {
  description = "Name identifier for CloudFront OAC and distribution"
  type        = string
}

variable "s3_bucket_domain_name" {
  description = "Regional domain name of S3 bucket for frontend"
  type        = string
}

variable "alb_dns_name" {
  description = "DNS name of ALB for API origin"
  type        = string
}

variable "acm_certificate_arn" {
  description = "ACM certificate ARN for HTTPS"
  type        = string
}

variable "aliases" {
  description = "Domain aliases for CloudFront (e.g. shopyyy.com, www.shopyyy.com)"
  type        = list(string)
  default     = []
}

variable "common_tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}
