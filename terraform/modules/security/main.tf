# 1. ALB Security Group (Public Internet Gateway Traffic)
resource "aws_security_group" "alb" {
  name        = "fintech-alb-sg-${var.environment}"
  description = "Allow inbound public HTTP web traffic to load balancer"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "fintech-alb-sg-${var.environment}" }
}

# 2. ECS Tasks Security Group (Internal Compute Routing Layer)
resource "aws_security_group" "ecs" {
  name        = "fintech-ecs-sg-${var.environment}"
  description = "Isolate containers to only accept incoming traffic from ALB"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "fintech-ecs-sg-${var.environment}" }
}

# 3. Database Security Group (Protected Backend Persistence Tier)
resource "aws_security_group" "db" {
  name        = "fintech-db-sg-${var.environment}"
  description = "Enforce database engine access strictly from the ECS compute group"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.ecs.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "fintech-db-sg-${var.environment}" }
}

# 4. ECS Task Execution IAM Role (Fixes the Copilot / Resource Missing Block)
resource "aws_iam_role" "ecs_execution_role" {
  name = "fintech-ecs-execution-role-${var.environment}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "ecs-tasks.amazonaws.com" }
    }]
  })

  tags = { Name = "fintech-ecs-execution-role-${var.environment}" }
}

# Attaches the AWS-managed core policy required for containers to boot, pipe logs, and pull images
resource "aws_iam_role_policy_attachment" "ecs_execution" {
  role       = aws_iam_role.ecs_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}