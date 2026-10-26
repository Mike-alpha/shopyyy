variable "domain_name" {
  description = "Primary domain name for ACM certificate"
  type        = string
}

variable "subject_alternative_names" {
  description = "Subject alternative names for certificate"
  type        = list(string)
  default     = []
}

variable "zone_id" {
  description = "Route53 zone ID for DNS validation"
  type        = string
}

variable "common_tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}
