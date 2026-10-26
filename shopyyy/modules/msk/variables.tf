variable "cluster_name" {
  description = "Name of the MSK Cluster"
  type        = string
}

variable "kafka_version" {
  description = "Apache Kafka version"
  type        = string
  default     = "3.5.1"
}

variable "broker_instance_type" {
  description = "MSK broker instance type"
  type        = string
  default     = "kafka.t3.small"
}

variable "private_subnet_ids" {
  description = "Private subnets across 2 AZs for MSK brokers"
  type        = list(string)
}

variable "security_group_ids" {
  description = "Security groups for MSK cluster"
  type        = list(string)
}

variable "common_tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}
