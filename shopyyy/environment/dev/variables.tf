variable "aws_region" {
  type    = string
  default = "ap-south-1"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "project" {
  type    = string
  default = "shopyyy"
}

variable "domain_name" {
  type    = string
  default = "shopyyy.com"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public_subnets" {
  type = any
}

variable "private_subnets" {
  type = any
}

variable "container_image" {
  type    = string
  default = "public.ecr.aws/ecs-sample-image/amazon-ecs-sample:latest"
}

variable "container_port" {
  type    = number
  default = 3000
}

variable "ecs_desired_count" {
  type    = number
  default = 2
}

variable "ecs_cpu" {
  type    = number
  default = 256
}

variable "ecs_memory" {
  type    = number
  default = 512
}

variable "db_name" {
  type    = string
  default = "shopyyydb"
}

variable "db_username" {
  type    = string
  default = "shopyyyadmin"
}

variable "db_instance_class" {
  type    = string
  default = "db.t3.medium"
}

variable "db_allocated_storage" {
  type    = number
  default = 20
}

variable "redis_node_type" {
  type    = string
  default = "cache.t3.micro"
}

variable "msk_kafka_version" {
  type    = string
  default = "3.5.1"
}

variable "msk_broker_instance_type" {
  type    = string
  default = "kafka.t3.small"
}

variable "s3_frontend_bucket_name" {
  type = string
}

variable "common_tags" {
  type    = map(string)
  default = {}
}
