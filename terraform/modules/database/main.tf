resource "aws_db_subnet_group" "main" {
  name       = "fintech-db-subnet-group-${var.environment}"
  subnet_ids = var.private_subnet_ids

  tags = { Name = "fintech-db-subnet-group-${var.environment}" }
}

resource "aws_db_instance" "postgres" {
  allocated_storage      = 20
  engine                 = "postgres"
  engine_version         = "16.3" 
  instance_class         = "db.t3.micro" 
  
  db_name                = var.db_name
  username               = var.username
  password               = var.password
  
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [var.db_sg_id]
  
  publicly_accessible    = false
  skip_final_snapshot    = true 

  depends_on = [aws_db_subnet_group.main]

  tags = { Name = "fintech-postgres-${var.environment}" }
}