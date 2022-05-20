variable "aws_region" {
  default = "us-east-1"
}
variable "cidr_block" {
  default = "10.0"
}
variable "project_name" {
  default = "test"
}
variable "tag_environment" {
  default = "infra"
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
