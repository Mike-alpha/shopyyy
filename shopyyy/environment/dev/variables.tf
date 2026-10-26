variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "ap-south-1"
}

variable "environment" {
  description = "Environment name (e.g. dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "project" {
  description = "Project name"
  type        = string
  default     = "shopyyy"
}

variable "domain_name" {
  description = "Primary domain name"
  type        = string
  default     = "shopyyy.com"
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnets" {
  description = "Public subnets configuration"
  type        = any
}

variable "private_subnets" {
  description = "Private subnets configuration"
  type        = any
}

variable "container_image" {
  description = "ECS container image"
  type        = string
  default     = "public.ecr.aws/ecs-sample-image/amazon-ecs-sample:latest"
}

variable "container_port" {
  description = "ECS container port"
  type        = number
  default     = 3000
}

variable "ecs_desired_count" {
  description = "Desired number of ECS tasks"
  type        = number
  default     = 2
}

variable "ecs_cpu" {
  description = "Fargate CPU units"
  type        = number
  default     = 256
}

variable "ecs_memory" {
  description = "Fargate Memory (MiB)"
  type        = number
  default     = 512
}

variable "db_name" {
  description = "PostgreSQL database name"
  type        = string
  default     = "shopyyydb"
}

variable "db_username" {
  description = "PostgreSQL master username"
  type        = string
  default     = "shopyyyadmin"
}

variable "db_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.medium"
}

variable "db_allocated_storage" {
  description = "RDS storage in GB"
  type        = number
  default     = 20
}

variable "redis_node_type" {
  description = "ElastiCache Redis node type"
  type        = string
  default     = "cache.t3.micro"
}

variable "msk_kafka_version" {
  description = "Apache Kafka version for MSK"
  type        = string
  default     = "3.5.1"
}

variable "msk_broker_instance_type" {
  description = "MSK broker instance type"
  type        = string
  default     = "kafka.t3.small"
}

variable "s3_frontend_bucket_name" {
  description = "S3 bucket name for frontend static assets"
  type        = string
}

variable "common_tags" {
  description = "Common tags applied to all resources"
  type        = map(string)
  default     = {}
}
