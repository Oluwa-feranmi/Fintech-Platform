variable "environment" {
  type        = string
  description = "Deployment environment name (e.g. dev, staging, prod)"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "Isolated private subnet IDs assigned for database placement"
}

variable "db_sg_id" {
  type        = string
  description = "The target firewall security group ID sealing database access"
}

variable "db_name" {
  type    = string
  default = "fintech_core"
}

variable "username" {
  type    = string
  default = "db_admin"
}

variable "password" {
  type      = string
  sensitive = true
}