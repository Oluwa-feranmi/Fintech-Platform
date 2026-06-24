output "db_host" {
  value       = aws_db_instance.postgres.address
  description = "The private connection endpoint endpoint string for application mapping"
}