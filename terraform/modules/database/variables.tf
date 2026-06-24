variable "private_subnet_ids" {
    type = list(string)
    description = "Target isolated subnets for the database cluster network placement"
}
variable "db_sg_id" {
  type = string
  description = "The security group firewall ID to isolate data tier ingress"
}
variable "db_name" {
  type = string
  description = "The physical database instance logical blueprint identifier"
}
variable "username" {
  type = string
  description = "Administrative primary master account username"
}
variable "password" {
  type = string
  description = "Primary account access credential passkey string"
  sensitive = true
}