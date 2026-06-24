# Group isolated private subnets across multiple AZs into a logical network cluster target
resource "aws_db_subnet_group" "main" {
  name        = "fintech-db-subnet-group-dev"
  subnet_ids  = var.private_subnet_ids
  description = "Enforces backend persistence subnets isolation"

  tags = {
    Name = "fintech-db-subnet-group-dev"
  }
}

# The primary database instance (Free Tier Engine Stack with Amazon Q Security Enhancements)
resource "aws_db_instance" "postgres" {
  identifier             = "fintech-core-db-dev"
  engine                 = "postgres"
  engine_version         = "15.4"
  instance_class         = "db.t3.micro" # Fully covered under AWS Free Tier
  allocated_storage      = 20            # 20GB GP2 storage allocation
  storage_type           = "gp2"
  
  db_name                = var.db_name
  username               = var.username
  password               = var.password
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [var.db_sg_id]

  # --- SECURITY PATCHES ---
  storage_encrypted                   = true  # Encrypts data at rest using default AWS KMS keys
  iam_database_authentication_enabled = true  # Enables secure IAM token-based login options

  skip_final_snapshot    = true          # Prevents termination hang/billing charges
  publicly_accessible    = false         # Explicit block from external routing table logic

  tags = {
    Name = "fintech-core-db-dev"
  }
}