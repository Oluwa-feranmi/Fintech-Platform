output "vpc_id" {
  description = "The Vpc ID"
  value = aws_vpc.my-vpc.id
}
output "public_subnet_ids" {
  description = "List of IDs of Public Subnets"
  value = aws_subnet.public.*.id
}
output "private_subnet_ids" {
  description = "List of IDs of Private Subnets"
  value = aws_subnet.private.*.id  
}