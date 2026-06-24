output "alb_sg_id" {
  description = "Security Group ID for Load Balancer assignment"
  value = aws_security_group.alb.id
}
output "ecs_sg_id" {
  description = "Security Group ID for ECS container enforcement"
  value = aws_security_group.ecs.id
}
output "db_sg_id" {
  description = "Security Group ID for RDS instance isolation"
  value = aws_security_group.DB.id
}
output "ecs_execution_role_arn" {
  description = "IAM Role ARN for Fargate task execution authorization"
  value = aws_iam_role.ecs_execution_role.arn
}