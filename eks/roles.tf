
resource "aws_iam_policy" "alb_ingress_policy" {
  name_prefix = "AWSLoadBalancerController"
  description = "EKS ALB ingress controller policy for cluster ${module.eks.cluster_id}"
  policy      = file("./eks/files/alb_ingress_policy.json")

  depends_on = [module.eks]
}

module "irsa_alb_ingress" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                       = "4.7.0"
  create_role                   = true
  role_name                     = local.iam_role
  provider_url                  = module.eks.cluster_oidc_issuer_url
  role_policy_arns              = [aws_iam_policy.alb_ingress_policy.arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:${local.namespace}:${local.service_account}"]

  depends_on = [aws_iam_policy.alb_ingress_policy]
}