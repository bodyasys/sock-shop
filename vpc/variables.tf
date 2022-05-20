# from .tfvars
variable "project_name" {}
variable "tag_environment" {}
variable "aws_region" {}
variable "cidr_block" {
  type    = string
  default = "10.10"
}
#variable "single_nat_gateway" {}
