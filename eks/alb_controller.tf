locals {
  iam_role        = "aws-load-balancer-controller"
  namespace       = "kube-system"
  service_account = "aws-load-balancer-controller"
}

resource "kubectl_manifest" "alb_crds" {
  yaml_body = data.http.alb_crds.body

  depends_on = [module.irsa_alb_ingress]
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
replicaCount: 1
serviceAccount:
  create: true
  name: ${local.service_account}
  annotations:
    eks.amazonaws.com/role-arn: arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${local.iam_role}
  vpcId: ${var.vpc_id}
  
EOF
  ]

  depends_on = [kubectl_manifest.alb_crds]

}

# resource "time_sleep" "wait_for_load_balancer_and_route53_record" {
#   depends_on       = [helm_release.alb_ingress]
#   destroy_duration = "120s"
# }

