variable "route_tables" {
  type    = any
  default = {}
}

variable "routes" {
  type    = any
  default = {}
}

variable "route_table_associations" {
  type    = any
  default = {}
}

variable "vpc_ids" {
  type    = map(string)
  default = {}
}

variable "igw_ids" {
  type    = map(string)
  default = {}
}

variable "nat_gateway_ids" {
  type    = map(string)
  default = {}
}

variable "subnet_ids" {
  type    = map(string)
  default = {}
}

variable "common_tags" {
  type    = map(string)
  default = {}
}
