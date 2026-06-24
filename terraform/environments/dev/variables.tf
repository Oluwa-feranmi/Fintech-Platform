variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "db_password" {
  type      = string
  sensitive = true
}

variable "docker_username" {
  type        = string
  description = "Your unique DockerHub handle matching your pushed image names"
}