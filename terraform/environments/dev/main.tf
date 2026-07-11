terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# 1. Core Isolation Network Module
module "network" {
  source               = "../../modules/network"
  vpc_cidr             = "10.0.0.0/16"
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.10.0/24", "10.0.11.0/24"]
  availability_zones   = ["${var.aws_region}a", "${var.aws_region}b"]
}

# 2. Firewall and IAM Security Group Mapping Tier
module "security" {
  source      = "../../modules/security"
  environment = "dev"
  vpc_id      = module.network.vpc_id
}

# 3. Protected Backend RDS Postgres Storage Group
module "database" {
  source             = "../../modules/database"
  environment        = "dev"
  private_subnet_ids = module.network.private_subnet_ids
  db_sg_id           = module.security.db_sg_id
  
  db_name            = "fintech_core"
  username           = "db_admin"
  password           = var.db_password
}

# 4. Compute Ingress Routing and Elastic Load Balancer 
module "compute" {
  source            = "../../modules/compute"
  vpc_id            = module.network.vpc_id
  public_subnet_ids = module.network.public_subnet_ids # Correctly reads from network outputs
  alb_sg_id         = module.security.alb_sg_id
}

# 5. ECS Fargate Container Deployment Engine
module "app" {
  source                 = "../../modules/app"
  cluster_name           = module.compute.cluster_name
  public_subnet_ids      = module.network.public_subnet_ids
  ecs_sg_id              = module.security.ecs_sg_id
  ecs_execution_role_arn = module.security.ecs_execution_role_arn
  docker_username        = var.docker_username

  tg_transaction_arn     = module.compute.tg_transaction_arn
  tg_fraud_arn           = module.compute.tg_fraud_arn
  tg_wallet_arn          = module.compute.tg_wallet_arn
  
  db_host                = module.database.db_host
  db_name                = "fintech_core"
  db_user                = "db_admin"
  db_password            = var.db_password
}

# 6. Static S3 React Front-End Web UI
module "frontend" {
  source      = "../../modules/frontend"
  bucket_name = "fintech-platform-ui-dev-${var.docker_username}"
}