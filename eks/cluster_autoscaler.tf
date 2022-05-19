locals {
  aws_iam_role_name_cluster_autoscaler = "test-${terraform.workspace}-cluster-autoscaler"
  k8s_ns_cluster_autoscaler            = "kube-system"
  k8s_sa_name_cluster_autoscaler       = "cluster-autoscaler"
}

module "irsa_cluster_autoscaler" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                       = "4.7.0"
  create_role                   = true
  role_name                     = local.aws_iam_role_name_cluster_autoscaler
  provider_url                  = replace(module.eks.cluster_oidc_issuer_url, "https://", "")
  role_policy_arns              = [aws_iam_policy.cluster_autoscaler.arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:${local.k8s_ns_cluster_autoscaler}:${local.k8s_sa_name_cluster_autoscaler}"]
}

resource "aws_iam_policy" "cluster_autoscaler" {
  name_prefix = "cluster-autoscaler"
  description = "EKS cluster-autoscaler policy for cluster ${module.eks.cluster_id}"
  policy      = data.aws_iam_policy_document.cluster_autoscaler.json
}

data "aws_iam_policy_document" "cluster_autoscaler" {
  statement {
    sid    = "clusterAutoscalerAll"
    effect = "Allow"

    actions = [
      "autoscaling:DescribeAutoScalingGroups",
      "autoscaling:DescribeAutoScalingInstances",
      "autoscaling:DescribeLaunchConfigurations",
      "autoscaling:DescribeTags",
      "ec2:DescribeLaunchTemplateVersions",
    ]

    resources = ["*"]
  }

  statement {
    sid    = "clusterAutoscalerOwn"
    effect = "Allow"

    actions = [
      "autoscaling:SetDesiredCapacity",
      "autoscaling:TerminateInstanceInAutoScalingGroup",
      "autoscaling:UpdateAutoScalingGroup",
    ]

    resources = ["*"]

    condition {
      test     = "StringEquals"
      variable = "autoscaling:ResourceTag/kubernetes.io/cluster/${module.eks.cluster_id}"
      values   = ["owned"]
    }

    condition {
      test     = "StringEquals"
      variable = "autoscaling:ResourceTag/k8s.io/cluster-autoscaler/enabled"
      values   = ["true"]
    }
  }
}

resource "helm_release" "cluster_autoscaler" {
  namespace  = local.k8s_ns_cluster_autoscaler
  repository = "https://kubernetes.github.io/autoscaler"
  name       = "cluster-autoscaler"
  chart      = "cluster-autoscaler"
  wait       = true
  version    = "9.12.0"
  timeout    = "300"

  values = [<<EOF
cloudProvider: aws
awsRegion: ${var.aws_region}
autoDiscovery:
  clusterName: ${local.cluster_name}
fullnameOverride: cluster-autoscaler
rbac:
  create: true
  pspEnabled: false
  serviceAccount:
    create: true
    name: ${local.k8s_sa_name_cluster_autoscaler}
    annotations:
      eks.amazonaws.com/role-arn: "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${local.aws_iam_role_name_cluster_autoscaler}"
EOF
  ]
}
