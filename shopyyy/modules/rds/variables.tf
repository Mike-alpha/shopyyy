variable "identifier" {
  description = "Identifier for the RDS instance"
  type        = string
}

variable "db_name" {
  description = "Initial database name"
  type        = string
  default     = "shopyyydb"
}

variable "username" {
  description = "Master username for database"
  type        = string
  default     = "shopyyyadmin"
}

variable "instance_class" {
  description = "Database instance class"
  type        = string
  default     = "db.t3.medium"
}

variable "allocated_storage" {
  description = "Allocated storage in GB"
  type        = number
  default     = 20
}

variable "private_subnet_ids" {
  description = "Private subnet IDs for DB subnet group"
  type        = list(string)
}

variable "security_group_ids" {
  description = "Security group IDs for RDS"
  type        = list(string)
}

variable "common_tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}
