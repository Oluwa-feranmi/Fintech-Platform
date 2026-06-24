# ==========================================
# 1. TRANSACTION MICROSERVICE
# ==========================================
resource "aws_ecs_task_definition" "transaction" {
  family                   = "transaction-task-dev"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = var.ecs_execution_role_arn

  container_definitions = jsonencode([{
    name      = "transaction"
    image     = "${var.docker_username}/transaction-service:v1"
    essential = true
    portMappings = [{ containerPort = 8080, hostPort = 8080 }]
    environment = [
      { name = "DB_HOST", value = var.db_host },
      { name = "DB_NAME", value = var.db_name },
      { name = "DB_USER", value = var.db_user },
      { name = "DB_PASSWORD", value = var.db_password }
    ]
  }])
}

resource "aws_ecs_service" "transaction" {
  name            = "transaction-service"
  cluster         = var.cluster_name
  task_definition = aws_ecs_task_definition.transaction.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.public_subnet_ids
    security_groups  = [var.ecs_sg_id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = var.tg_transaction_arn
    container_name   = "transaction"
    container_port   = 8080
  }
}

# ==========================================
# 2. FRAUD MICROSERVICE
# ==========================================
resource "aws_ecs_task_definition" "fraud" {
  family                   = "fraud-task-dev"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = var.ecs_execution_role_arn

  container_definitions = jsonencode([{
    name      = "fraud"
    image     = "${var.docker_username}/fraud-service:v1"
    essential = true
    portMappings = [{ containerPort = 8080, hostPort = 8080 }]
    environment = [
      { name = "DB_HOST", value = var.db_host },
      { name = "DB_NAME", value = var.db_name },
      { name = "DB_USER", value = var.db_user },
      { name = "DB_PASSWORD", value = var.db_password }
    ]
  }])
}

resource "aws_ecs_service" "fraud" {
  name            = "fraud-service"
  cluster         = var.cluster_name
  task_definition = aws_ecs_task_definition.fraud.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.public_subnet_ids
    security_groups  = [var.ecs_sg_id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = var.tg_fraud_arn
    container_name   = "fraud"
    container_port   = 8080
  }
}

# ==========================================
# 3. WALLET MICROSERVICE
# ==========================================
resource "aws_ecs_task_definition" "wallet" {
  family                   = "wallet-task-dev"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = var.ecs_execution_role_arn

  container_definitions = jsonencode([{
    name      = "wallet"
    image     = "${var.docker_username}/wallet-service:v1"
    essential = true
    portMappings = [{ containerPort = 8080, hostPort = 8080 }]
    environment = [
      { name = "DB_HOST", value = var.db_host },
      { name = "DB_NAME", value = var.db_name },
      { name = "DB_USER", value = var.db_user },
      { name = "DB_PASSWORD", value = var.db_password }
    ]
  }])
}

resource "aws_ecs_service" "wallet" {
  name            = "wallet-service"
  cluster         = var.cluster_name
  task_definition = aws_ecs_task_definition.wallet.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.public_subnet_ids
    security_groups  = [var.ecs_sg_id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = var.tg_wallet_arn
    container_name   = "wallet"
    container_port   = 8080
  }
}