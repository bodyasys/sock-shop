module "vpc" {
  source          = "./vpc"
  aws_region      = var.aws_region
  cidr_block      = var.cidr_block
  project_name    = var.project_name
  tag_environment = var.tag_environment
  #single_nat_gateway = var.single_nat_gateway
}
module "eks" {
  source          = "./eks"
  aws_region      = var.aws_region
  project_name    = var.project_name
  tag_environment = var.tag_environment
  vpc_id          = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnets
  public_subnets  = module.vpc.public_subnets
  iam_user_name   = var.iam_user_name

}

module "shop" {
  source     = "./shop"
  cluster_id = module.eks.cluster_id

}