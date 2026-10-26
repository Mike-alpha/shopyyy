variable "domain_name" {
  description = "Domain name for hosted zone"
  type        = string
}

variable "cloudfront_domain_name" {
  description = "CloudFront domain name for alias"
  type        = string
  default     = ""
}

variable "cloudfront_hosted_zone_id" {
  description = "CloudFront hosted zone ID"
  type        = string
  default     = "Z2FDTNDATAQYW2" # Constant hosted zone ID for all CloudFront distributions
}

variable "common_tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}
