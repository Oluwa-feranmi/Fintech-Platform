module "network" {
  source               = "../../modules/network"
  vpc_cidr             = "10.0.0.0/16"
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.10.0/24", "10.0.11.0/24"]
  availability_zones   = ["${var.aws_region}a", "${var.aws_region}b"]
}

module "security" {
  source = "../../modules/security"
  vpc_id = module.network.vpc_id
}

module "database" {
  source             = "../../modules/database"
  private_subnet_ids = module.network.private_subnet_ids
  db_sg_id           = module.security.db_sg_id
  
  db_name            = "fintech_core"
  username           = "db_admin"
  password           = var.db_password
}

module "compute" {
  source            = "../../modules/compute"
  vpc_id            = module.network.vpc_id
  public_subnet_ids = module.network.public_subnet_ids
  alb_sg_id         = module.security.alb_sg_id
}

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
module "frontend" {
  source      = "../../modules/frontend"
  bucket_name = "fintech-platform-ui-dev-${var.docker_username}" # Dynamic naming to prevent collisions
}