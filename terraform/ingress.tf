resource "kubernetes_namespace" "ingress_nginx" {
  metadata {
    name = "ingress-nginx"

    annotations = {
      "linkerd.io/inject" = "enabled"
    }
  }
}

resource "helm_release" "ingress_nginx" {
  depends_on = [
    helm_release.linkerd2
  ]

  name       = "ingress-nginx"
  namespace  = kubernetes_namespace.ingress_nginx.metadata.0.name
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version    = var.ingress_nginx_version

  atomic      = true
  wait        = true
  max_history = 2

  values = [
    file("ingress-nginx-helm-values.yaml")
  ]
}
