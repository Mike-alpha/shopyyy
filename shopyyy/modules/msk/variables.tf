variable "cluster_name" {
  type = string
}

variable "kafka_version" {
  type    = string
  default = "3.5.1"
}

variable "broker_instance_type" {
  type    = string
  default = "kafka.t3.small"
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "security_group_ids" {
  type = list(string)
}

variable "common_tags" {
  type    = map(string)
  default = {}
}
