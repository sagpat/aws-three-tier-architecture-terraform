module "networking" {
  source            = "./networking"
  availability_zone = var.availability_zone
  aws_subnets       = var.aws_subnets
  flattened_subnets = local.flattened_subnets
}

module "storage" {
  source           = "./storage"
  application_name = var.application_name
  db_host = module.database.aws_rds_cluster_endpoint
  db_user = var.db_user
  db_pwd = var.db_pwd
  db_database = var.db_database
}

module "iam_roles" {
  source            = "./iam"
  aws_managed_roles = var.aws_managed_roles
}

module "database" {
  source            = "./database"
  flattened_subnets = local.flattened_subnets
  aws_subnet_ids    = module.networking.aws_subnet_ids
  db_security_group = module.networking.db_sg.id
  db_user = var.db_user
  db_pwd = var.db_pwd
}

module "compute_app_tier" {
  source                   = "./compute/app-tier-deployment"
  aws_iam_instance_profile = module.iam_roles.aws_iam_instance_profile
  aws_subnet_ids           = module.networking.aws_subnet_ids
  private_instance_sg      = module.networking.private_instance_sg.id
  flattened_subnets        = local.flattened_subnets
  rds_writer_endpoint      = module.database.aws_rds_cluster_endpoint
  s3_bucket_name           = module.storage.s3_bucket_name
  aws_vpc_id               = module.networking.aws_vpc_id.id
  internal_lb_sg           = module.networking.internal_lb_sg.id
}