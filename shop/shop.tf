resource "helm_release" "socks-shop" {
  name    = "helm-chart"
  chart   = "./shop/helm-chart"
  timeout = "1800"
}