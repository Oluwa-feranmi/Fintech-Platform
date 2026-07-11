variable "environment" {
  type        = string
  description = "Deployment environment name (e.g. dev, staging, prod)"
}

variable "vpc_id" {
  type        = string
  description = "The ID of the target VPC where security elements will align"
}