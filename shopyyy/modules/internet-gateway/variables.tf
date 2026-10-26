variable "internet_gateways" {
  type = any
}

variable "vpc_ids" {
  type    = map(string)
  default = {}
}

variable "common_tags" {
  type    = map(string)
  default = {}
}
