output "backend_api_gateway_url" {
  value       = "http://${module.compute.alb_dns_name}"
  description = "The raw JSON load balancer API gateway endpoint"
}

output "live_web_ui_url" {
  value       = module.frontend.website_url
  description = "VISUAL SCREENSHOT TARGET: The public web address for your frontend application portal"
}