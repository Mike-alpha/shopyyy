variable "cluster_name" {
  description = "Name of the ECS Cluster"
  type        = string
}

variable "service_name" {
  description = "Name of the ECS Service"
  type        = string
}

variable "container_image" {
  description = "Container image for ECS task"
  type        = string
  default     = "public.ecr.aws/ecs-sample-image/amazon-ecs-sample:latest"
}

variable "container_port" {
  description = "Port exposed by the container"
  type        = number
  default     = 3000
}

variable "cpu" {
  description = "CPU units for task definition"
  type        = number
  default     = 256
}

variable "memory" {
  description = "Memory (in MiB) for task definition"
  type        = number
  default     = 512
}

variable "desired_count" {
  description = "Desired number of tasks running"
  type        = number
  default     = 2
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for tasks"
  type        = list(string)
}

variable "security_group_ids" {
  description = "Security group IDs for ECS tasks"
  type        = list(string)
}

variable "target_group_arn" {
  description = "Target group ARN for ALB integration"
  type        = string
}

variable "db_secret_arn" {
  description = "Secrets Manager ARN for database credentials"
  type        = string
  default     = ""
}

variable "db_url" {
  description = "Database URL"
  type        = string
  default     = ""
}

variable "redis_url" {
  description = "Redis URL"
  type        = string
  default     = ""
}

variable "common_tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}
