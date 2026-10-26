variable "subnets" {
  description = "Map of Subnet configurations"
  type        = any
}

variable "vpc_ids" {
  description = "Map of VPC IDs"
  type        = map(string)
  default     = {}
}

variable "common_tags" {
  description = "Common tags to apply to resources"
  type        = map(string)
  default     = {}
}
