variable "nat_gateways" {
  type = any
}

variable "subnet_ids" {
  type    = map(string)
  default = {}
}

variable "common_tags" {
  type    = map(string)
  default = {}
}
