resource "aws_ecs_cluster" "main" {
  name = "fintech-cluster-${var.environment}"
}

resource "aws_lb" "main" {
  name               = "fintech-alb-${var.environment}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_sg_id]
  subnets            = var.public_subnet_ids

  # --- SECURITY PATCH ---
  drop_invalid_header_fields = true # Mitigates HTTP header injection vulnerabilities

  enable_deletion_protection = false
}

# --- THREE TARGET GROUPS ---
resource "aws_lb_target_group" "transaction" {
  name        = "tg-transaction-${var.environment}"
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"
  health_check {
    path = "/health"
  }
}

resource "aws_lb_target_group" "fraud" {
  name        = "tg-fraud-${var.environment}"
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"
  health_check {
    path = "/fraud/health"
  }
}

resource "aws_lb_target_group" "wallet" {
  name        = "tg-wallet-${var.environment}"
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"
  health_check {
    path = "/wallet/health"
  }
}

# --- ALB PORT 80 LISTENER ---
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = "80"
  protocol          = "HTTP"

  # Default fallback action loops to transactions
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.transaction.arn
  }
}

# --- PATH ROUTING RULES ---
resource "aws_lb_listener_rule" "fraud_rule" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 10

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.fraud.arn
  }
  condition {
    path_pattern {
      values = ["/api/fraud*", "/fraud/*"]
    }
  }
}

resource "aws_lb_listener_rule" "wallet_rule" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 20

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.wallet.arn
  }
  condition {
    path_pattern {
      values = ["/api/wallet*", "/wallet/*"]
    }
  }
}