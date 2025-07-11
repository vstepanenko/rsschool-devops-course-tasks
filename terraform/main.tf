# Get current region
data "aws_region" "current" {}
locals {
  current_region = data.aws_region.current.name
}
# Create VPC and subnets
module "vpc" {
  source   = "./modules/vpc"
  vpc_cidr = var.vpc_cidr
}
# Create subnets
module "networks" {
  source               = "./modules/networks"
  vpc_id               = module.vpc.vpc_id
  aws_region           = local.current_region
  private_subnet_cidrs = var.private_subnet_cidrs
  public_subnet_cidrs  = var.public_subnet_cidrs
}
# Create Security Groups
module "security_groups" {
  source                    = "./modules/security"
  vpc_id                    = module.vpc.vpc_id
  allowed_ssh_bastion_cidrs = var.allowed_ssh_bastion_cidrs
}
# Create EC2 instances
module "ec2" {
  source                   = "./modules/ec2"
  aws_region               = local.current_region
  public_ssh_key           = var.public_ssh_key
  private_subnet_ids       = module.networks.private_subnet_ids
  public_subnet_ids        = module.networks.public_subnet_ids
  bastion_host_group_id    = module.security_groups.bastion_host_group_id
  private_hosts_group_id   = module.security_groups.private_hosts_group_id
  private_route_table_id   = module.networks.private_route_table_id
}
# Create Network ACLs
module "acl" {
  source            = "./modules/acl"
  vpc_id            = module.vpc.vpc_id
  blocked_cidrs     = var.blocked_cidrs
  public_subnet_ids = module.networks.public_subnet_ids
}