# locals {
#   aws_iam_role_name_external_dns = "trends-${terraform.workspace}-external-dns"
#   k8s_sa_name_external_dns       = "external-dns"
# }

# // external DNS
# module "irsa_external_dns" {
#   source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
#   version                       = "4.7.0"
#   create_role                   = true
#   role_name                     = local.aws_iam_role_name_external_dns
#   provider_url                  = replace(module.eks.cluster_oidc_issuer_url, "https://", "")
#   role_policy_arns              = [aws_iam_policy.external_dns.arn]
#   oidc_fully_qualified_subjects = ["system:serviceaccount:${local.namespace}:${local.k8s_sa_name_external_dns}"]
# }

# resource "aws_iam_policy" "external_dns" {
#   name_prefix = "external-dns"
#   description = "EKS external-dns manager policy for cluster ${module.eks.cluster_id}"
#   policy      = data.aws_iam_policy_document.external_dns.json
# }

# data "aws_iam_policy_document" "external_dns" {
#   statement {
#     effect = "Allow"

#     actions = [
#       "route53:ListHostedZones",
#       "route53:ListResourceRecordSets",
#       "route53:ChangeResourceRecordSets"
#     ]

#     resources = ["*"]
#   }
# }

# resource "helm_release" "external_dns" {
#   namespace  = local.namespace
#   repository = "https://charts.bitnami.com/bitnami"
#   name       = "external-dns"
#   chart      = "external-dns"
#   wait       = true
#   timeout    = "300"

#   values = [<<EOF
# provider: aws
# aws:
#   zoneType: public
# txtOwnerId: ${var.route53_zone_id}
# domainFilters[0]: ${var.route53_zone_name}
# policy: sync
# serviceAccount:
#   create: true
#   name: ${local.k8s_sa_name_external_dns}
#   annotations:
#     eks.amazonaws.com/role-arn: arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${local.aws_iam_role_name_external_dns}
# EOF
#   ]
# }

# output "helm_release_metadata" {
#   value = helm_release.external_dns.metadata
# }
