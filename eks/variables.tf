variable "project_name" {}
variable "tag_environment" {}

variable "vpc_id" {
  type = string
}
variable "private_subnets" {
  type = list(any)
}
variable "public_subnets" {
  type = list(any)
}
variable "aws_region" {}

variable "iam_alb_role_name" {
  default     = "aws-load-balancer-controller"
  description = "The name for aws load balancer controller"
}
variable "sa_namespace" {
  default     = "kube-system"
  description = "Service Account namespace"
}
variable "helm_timeout" {
  type        = number
  default     = 400
  description = "Default Helm Release timeout"
}


variable "iam_user_name" {
  default     = "bvvovkservice@gmail.com"
  type        = string
  description = "Your IAM user"
}

variable "iam_user_arn" {
  default     = "arn:aws:iam:::user/"
  type        = string
  description = "Your user IAM arn"
}

variable "kub_groups" {
  default     = "system:masters"
  description = "Kubernetes Group"
}
