variable "cluster_id" {
  description = "Cluster ID for ElastiCache Redis"
  type        = string
}

variable "node_type" {
  description = "ElastiCache node type"
  type        = string
  default     = "cache.t3.micro"
}

variable "private_subnet_ids" {
  description = "Private subnet IDs for Redis subnet group"
  type        = list(string)
}

variable "security_group_ids" {
  description = "Security group IDs for Redis"
  type        = list(string)
}

variable "common_tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}
