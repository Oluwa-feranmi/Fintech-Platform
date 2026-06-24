output "alb_sg_id" {
  value       = aws_security_group.alb.id
  description = "The ID of the security group guarding the Application Load Balancer"
}

output "ecs_sg_id" {
  value       = aws_security_group.ecs.id
  description = "The ID of the security group assigned to Fargate microservice containers"
}

output "db_sg_id" {
  value       = aws_security_group.db.id
  description = "The ID of the security group sealing the RDS database tier"
}

output "ecs_execution_role_arn" {
  value       = aws_iam_role.ecs_execution_role.arn
  description = "The verified Amazon Resource Name identity for task configuration parsing"
}