variable "identifier" {
  type = string
}

variable "db_name" {
  type    = string
  default = "shopyyydb"
}

variable "username" {
  type    = string
  default = "shopyyyadmin"
}

variable "instance_class" {
  type    = string
  default = "db.t3.medium"
}

variable "allocated_storage" {
  type    = number
  default = 20
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
