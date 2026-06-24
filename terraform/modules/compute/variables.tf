variable "vpc_id" {
  description = "The target VPC ID where the ALB target group will be registered"
  type = string
}
variable "public_subnet_ids" {
  description = "Public subnets where the Application Load Balancer will be provisioned"
  type = list(string)
}
variable "alb_sg_id" {
  description = "Security group firewall ID attached to the public ALB"
  type = string
}