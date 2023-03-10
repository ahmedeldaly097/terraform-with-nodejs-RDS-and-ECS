terraform {
  required_version = ">= 0.14"
}

provider "aws" {
  region = "us-east-1"
  profile = terraform.workspace
}

module "vpc" {
  source = "./modules/vpc"

  cidr_block = "10.0.0.0/16"
  name       = "my_vpc"
}

module "ecs" {
  source = "./modules/ecs"

  vpc_id          = module.vpc.vpc_id
  public_subnet_ids  = module.vpc.public_subnet_ids
  private_subnet_ids = module.vpc.private_subnet_ids

  app_image        = "my-node-app:latest"
  container_memory = 256
  container_port   = 80
  target_group_arn = module.alb.target_group_arn
}

module "alb" {
  source = "./modules/alb"

  vpc_id              = module.vpc.vpc_id
  public_subnet_ids   = module.vpc.public_subnet_ids
  alb_security_group = module.ecs.ecs_security_group_id

  listener_arn = module.cloudfront.alb_listener_arn
}

module "rds" {
  source = "./modules/rds"

  vpc_id          = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  rds_security_group  = module.ecs.ecs_security_group_id

  database_name = "my_database"
  engine       = "mysql"
  engine_version = "5.7"
  instance_class = "db.t2.micro"
  username       = "admin"
  password       = "password"
}

module "cloudfront" {
  source = "./modules/cloudfront"

  public_subnet_ids = module.vpc.public_subnet_ids
  s3_bucket_arn     = "arn:aws:s3:::my-bucket"
}

// Outputs

output "app_url" {
  value = module.alb.alb_dns_name
}

output "rds_endpoint" {
  value = module.rds.endpoint
}
