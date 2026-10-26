variable "bucket_name" {
  type = string
}

variable "cloudfront_distribution_arn" {
  type    = string
  default = ""
}

variable "common_tags" {
  type    = map(string)
  default = {}
}
