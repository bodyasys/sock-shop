locals {
  cluster_name = "${var.project_name}-${var.tag_environment}-eks-cluster"
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "17.1.0"

  cluster_name    = local.cluster_name
  cluster_version = "1.22"

  vpc_id  = var.vpc_id
  subnets = var.private_subnets
  map_users = [
    {
      userarn  = var.iam_user_name
      username = var.iam_user_arn
      groups   = [var.kub_groups]
    }
  ]

  node_groups = {

    services = {
      desired_capacity = 3
      max_capacity     = 20
      min_capacity     = 3

      instance_types = ["t3.large"]
      capacity_type  = "ON_DEMAND"

      update_config = {
        max_unavailable_percentage = 50 # or set `max_unavailable`
      }
    }


  }



  cluster_endpoint_private_access                = true
  cluster_create_endpoint_private_access_sg_rule = true
  cluster_endpoint_private_access_cidrs          = ["0.0.0.0/0"]
  cluster_endpoint_public_access                 = true
  workers_additional_policies                    = ["arn:aws:iam::aws:policy/CloudWatchLogsFullAccess", "arn:aws:iam::aws:policy/AWSXRayDaemonWriteAccess"]
  write_kubeconfig                               = false

  enable_irsa = true
}