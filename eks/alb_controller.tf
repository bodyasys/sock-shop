locals {
  iam_role        = "test-${terraform.workspace}-alb-ingress"
  namespace       = "kube-system"
  service_account = "alb-ingress"
}

data "http" "alb_crds" {
  url = "https://raw.githubusercontent.com/aws/eks-charts/master/stable/aws-load-balancer-controller/crds/crds.yaml"
}

resource "aws_iam_policy" "alb_ingress_policy" {
  name_prefix = "aws_alb"
  description = "EKS ALB ingress controller policy for cluster ${module.eks.cluster_id}"
  policy      = file("./eks/files/alb_ingress_policy.json")
}

module "irsa_alb_ingress" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                       = "4.7.0"
  create_role                   = true
  role_name                     = local.iam_role
  provider_url                  = replace(module.eks.cluster_oidc_issuer_url, "https://", "")
  role_policy_arns              = [aws_iam_policy.alb_ingress_policy.arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:${local.namespace}:${local.service_account}"]
}

resource "kubectl_manifest" "alb_crds" {
  yaml_body = data.http.alb_crds.body
}

resource "helm_release" "alb_ingress" {
  namespace  = local.namespace
  repository = "https://aws.github.io/eks-charts"
  name       = "aws-load-balancer-controller"
  chart      = "aws-load-balancer-controller"
  wait       = true
  timeout    = "300"

  values = [<<EOF
clusterName: ${local.cluster_name}
region: ${var.aws_region}
serviceAccount:
  create: true
  name: ${local.service_account}
  annotations:
    eks.amazonaws.com/role-arn: arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${local.iam_role}
  vpcId: ${var.vpc_id}
EOF
  ]
}

resource "time_sleep" "wait_for_load_balancer_and_route53_record" {
  depends_on       = [helm_release.alb_ingress]
  destroy_duration = "120s"
}

