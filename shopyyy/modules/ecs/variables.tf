variable "cluster_name" {

  type = string
}

variable "service_name" {

  type = string
}

variable "container_image" {

  type    = string
  default = "public.ecr.aws/ecs-sample-image/amazon-ecs-sample:latest"
}

variable "container_port" {

  type    = number
  default = 3000
}

variable "cpu" {

  type    = number
  default = 256
}

variable "memory" {

  type    = number
  default = 512
}

variable "desired_count" {

  type    = number
  default = 2
}

variable "private_subnet_ids" {

  type = list(string)
}

variable "security_group_ids" {
  type = list(string)
}

variable "target_group_arn" {

  type = string
}

variable "db_secret_arn" {

  type    = string
  default = ""
}

variable "db_url" {

  type    = string
  default = ""
}

variable "redis_url" {

  type    = string
  default = ""
}

variable "common_tags" {

  type    = map(string)
  default = {}
}
