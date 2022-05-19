# data "kubectl_path_documents" "shop" {
#   pattern = "${path.module}/files/files/*.yaml"
# }

# resource "kubectl_manifest" "shop" {
#   count     = length(data.kubectl_path_documents.manifests.documents)
#   yaml_body = element(data.kubectl_path_documents.manifests.documents, count.index)
# }
