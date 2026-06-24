output "website_url" {
  value       = "http://${aws_s3_bucket_website_configuration.frontend.website_endpoint}"
  description = "The public browser URL to access your visual Fintech Web UI"
}

output "bucket_name" {
  value = aws_s3_bucket.frontend.id
}