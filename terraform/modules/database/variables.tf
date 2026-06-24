variable "db_name" {
  description = "Database name"
  type        = string
}

variable "username" {
  description = "Database master username"
  type        = string
}

variable "password" {
  description = "Database master password"
  type        = string
  sensitive   = true
}

variable "private_subnet_ids" {
  description = "Private subnet IDs for RDS"
  type        = list(string)
}

variable "db_sg_id" {
  description = "Security group ID for database"
  type        = string
}