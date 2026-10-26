variable "name" {
  type = string
}

variable "s3_bucket_domain_name" {
  type = string
}

variable "alb_dns_name" {
  type = string
}

variable "acm_certificate_arn" {
  type = string
}

variable "aliases" {
  type    = list(string)
  default = []
}

variable "common_tags" {
  type    = map(string)
  default = {}
}
