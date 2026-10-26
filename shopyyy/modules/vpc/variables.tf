variable "vpcs" {
  description = "Map of VPC configurations"
  type        = any
}

variable "common_tags" {
  description = "Common tags to apply to resources"
  type        = map(string)
  default     = {}
}
