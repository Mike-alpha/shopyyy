variable "nat_gateways" {
  description = "Map of NAT Gateway configurations"
  type        = any
}

variable "subnet_ids" {
  description = "Map of Subnet IDs"
  type        = map(string)
  default     = {}
}

variable "common_tags" {
  description = "Common tags to apply to resources"
  type        = map(string)
  default     = {}
}
