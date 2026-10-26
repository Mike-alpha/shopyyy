variable "domain_name" {
  type = string
}

variable "cloudfront_domain_name" {
  type    = string
  default = ""
}

variable "cloudfront_hosted_zone_id" {
  type    = string
  default = "Z2FDTNDATAQYW2"
}

variable "common_tags" {
  type    = map(string)
  default = {}
}
