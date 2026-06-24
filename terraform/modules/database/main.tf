# 1. Dedicated Subnet Grouping across multiple Availability Zones
resource "aws_db_subnet_group" "main" {
  name       = "fintech-db-subnet-group-dev"
  subnet_ids = var.private_subnet_ids

  tags = { Name = "fintech-db-subnet-group-dev" }
}

# 2. Main Relational Database Engine
resource "aws_db_instance" "postgres" {
  allocated_storage      = 20
  max_allocated_storage  = 50
  engine                 = "postgres"
  engine_version         = "16.3" # Enforcing a globally available, stable engine release
  instance_class         = "db.t3.micro" # Fits cleanly into AWS Free Tier options
  
  db_name                = var.db_name
  username               = var.username
  password               = var.password
  
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [var.db_sg_id]
  
  publicly_accessible    = false
  
  # CRITICAL FOR TEARDOWN: Prevents AWS from hanging onto an un-deletable storage backup when destroying
  skip_final_snapshot    = true 

  # Explicit lifecycle block to ensure the network boundary initializes first
  depends_on = [aws_db_subnet_group.main]

  tags = { Name = "fintech-postgres-dev" }
}