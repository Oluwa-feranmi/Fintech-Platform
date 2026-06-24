variable "aws_region" {
  type    = string
  default = "eu-west-1"
}

variable "db_password" {
  type      = string
  sensitive = true
}

variable "docker_username" {
  type        = string
  description = "DockerHub account username used to build image pathways"
}