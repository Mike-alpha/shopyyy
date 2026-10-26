variable "cluster_id" {
  type = string
}

variable "node_type" {
  type    = string
  default = "cache.t3.micro"
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
