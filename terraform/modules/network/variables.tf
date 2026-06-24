variable "vpc_cidr" {
  type = string
  description = "The CIDR block for the VPC"
}

variable "public_subnet_cidrs" {
  type = list(string)
  description = "List of CIDRs for Public Subnets"
}

variable "private_subnet_cidrs" {
  type = list(string)
  description = "List of CIDRs for Private Subnets"
}

variable "availability_zones" {
  type = list(string)
  description = "Target deployment Availability zones"
}