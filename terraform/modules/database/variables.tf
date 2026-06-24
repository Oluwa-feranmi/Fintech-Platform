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

variable "db_user" {
  type    = string
  default = "db_admin"
}

variable "db_password" {
  type      = string
  sensitive = true
}