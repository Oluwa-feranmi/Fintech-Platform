output "db_endpoint" {
  description = "The combined host connection network endpoint protocol string (host:port)"
  value = aws_db_instance.postgres.endpoint
}
output "db_host" {
  description = "The raw internal DNS endpoint vector address of the database"
  value = aws_db_instance.postgres.address
}