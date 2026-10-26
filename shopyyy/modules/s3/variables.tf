variable "bucket_name" {
  description = "Name of the S3 bucket for frontend"
  type        = string
}

variable "cloudfront_distribution_arn" {
  description = "CloudFront Distribution ARN for bucket policy"
  type        = string
  default     = ""
}

variable "common_tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}
