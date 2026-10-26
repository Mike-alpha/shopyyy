variable "name" {
  description = "Name prefix for the ALB and Target Group"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs"
  type        = list(string)
}

variable "security_group_ids" {
  description = "List of security group IDs for ALB"
  type        = list(string)
}

variable "certificate_arn" {
  description = "ACM certificate ARN for HTTPS listener"
  type        = string
}

variable "health_check_path" {
  description = "Health check path for target group"
  type        = string
  default     = "/api/health"
}

variable "common_tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}
