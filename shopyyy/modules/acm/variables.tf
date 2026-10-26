variable "domain_name" {
  type = string
}

variable "subject_alternative_names" {
  type    = list(string)
  default = []
}

variable "zone_id" {
  type = string
}

variable "common_tags" {
  type    = map(string)
  default = {}
}
