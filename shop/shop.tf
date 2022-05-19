resource "helm_release" "socks-shop" {
  name       = "helm-chart"
  chart      = "./helm-chart"

}