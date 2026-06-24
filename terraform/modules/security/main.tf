resource "aws_security_group" "alb" {
  name        = "fintech-alb-sg-dev"
  description = "Explicit internet ingress firewall perimeter"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow public HTTP traffic"
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

  tags = {
    Name = "fintech-alb-sg-dev"
  }
}
resource "aws_security_group" "ecs" {
  name        = "fintech-ecs-sg-dev"
  description = "App tier firewall isolating microservices"
  vpc_id      = var.vpc_id

  ingress {
    description = "Isolate ingress exclusively to traffic originating from the ALB"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  egress {
    description = "Allow containers to pull images and write logs out"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "fintech-ecs-sg-dev"
  }
}
resource "aws_security_group" "DB" {
  name        = "fintech-db-sg-dev"
  description = "Strict data tier firewall perimeter"
  vpc_id      = var.vpc_id

  ingress {
    description = "Isolate database ingress exclusively to the app container tier"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    security_groups = [aws_security_group.ecs.id]
  }

  egress {
    description = "Prevent database from establishing outbound web connections"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "fintech-db-sg-dev"
  }
}
resource "aws_iam_role" "ecs-execution-role" {
  name = "test_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      },
    ]
  })
}
resource "aws_iam_policy_attachment" "ecs-policy-attachment" {
  name       = "test-attachment"
  roles      = [aws_iam_role.ecs-execution-role.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
