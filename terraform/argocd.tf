# resource "helm_release" "argocd" {
#   name             = "argocd"
#   namespace        = "argocd"
#   create_namespace = true
#
#   repository = "https://argoproj.github.io/argo-helm"
#   chart      = "argo-cd"
#   version    = "8.2.6"
#
#   # values = [
#   #   file("${path.module}/argocd-values.yaml") # Optional, for custom configs
#   # ]
# }