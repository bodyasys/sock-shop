data "aws_caller_identity" "current" {}

data "http" "applytargetfroupbinding" {
  url = "https://raw.githubusercontent.com/aws/eks-charts/master/stable/aws-load-balancer-controller/crds/crds.yaml"
}
