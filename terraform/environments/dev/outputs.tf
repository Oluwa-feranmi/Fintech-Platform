output "vpc_id" {
  description = "The Vpc ID"
  value = aws_vpc.my_vpc.id
}
output "public_subnet_ids" {
  description = "List of IDs of Public Subnets"
  value = aws_subnet.public.*.id
}
output "private_subnet_ids" {
  description = "List of IDs of Private Subnets"
  value = aws_subnet.private.*.id  
}
output "application_url" {
  value       = "http://${module.compute.alb_dns_name}"
  description = "The public web gateway address for your fintech application platform"
}
output "backend_api_gateway_url" {
  value       = "http://${module.compute.alb_dns_name}"
  description = "The raw JSON load balancer API gateway endpoint"
}

output "live_web_ui_url" {
  value       = module.frontend.website_url
  description = "VISUAL SCREENSHOT TARGET: The public web address for your frontend application portal"
}