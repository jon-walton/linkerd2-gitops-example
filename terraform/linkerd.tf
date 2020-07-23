resource "tls_private_key" "linkerd_trust_anchor" {
  algorithm = "RSA"
}

resource "tls_self_signed_cert" "linkerd_trust_anchor" {
  subject {
    common_name = "identity.linkerd.cluster.local"
  }

  private_key_pem   = tls_private_key.linkerd_trust_anchor.private_key_pem
  key_algorithm     = tls_private_key.linkerd_trust_anchor.algorithm
  is_ca_certificate = true

  validity_period_hours = 24 * 365 * 10
  allowed_uses          = [
    "cert_signing",
    "crl_sign"
  ]
}

resource "kubernetes_namespace" "linkerd" {
  metadata {
    name = "linkerd"

    annotations = {
      "linkerd.io/inject" = "disabled"
    }

    labels = {
      "config.linkerd.io/admission-webhooks" = "disabled"
      "linkerd.io/is-control-plane"          = "true"
    }
  }
}

resource "kubernetes_secret" "linkerd_trust_anchor" {
  metadata {
    name      = "linkerd-trust-anchor"
    namespace = kubernetes_namespace.linkerd.metadata.0.name
  }

  type = "kubernetes.io/tls"
  data = {
    "ca.crt"  = ""
    "tls.crt" = tls_self_signed_cert.linkerd_trust_anchor.cert_pem
    "tls.key" = tls_private_key.linkerd_trust_anchor.private_key_pem
  }
}

resource "helm_release" "linkerd_certificates" {
  depends_on = [
    helm_release.cert_manager
  ]

  name      = "linkerd-certificates"
  namespace = kubernetes_namespace.linkerd.metadata.0.name
  chart     = "../charts/cert-manager-issuers"

  atomic      = true
  wait        = true
  max_history = 2
}


resource "helm_release" "linkerd2" {
  depends_on = [
    helm_release.linkerd_certificates
  ]

  name       = "linkerd2"
  namespace  = kubernetes_namespace.linkerd.metadata.0.name
  repository = format("https://helm.linkerd.io/%s", lower(var.linkerd_release))
  chart      = "linkerd2"
  version    = var.linkerd_version

  atomic      = true
  wait        = true
  max_history = 2

  values = [
    templatefile("linkerd-helm-values.tpl", {
      identityTrustAnchorsPEM = tls_self_signed_cert.linkerd_trust_anchor.cert_pem
    })
  ]
}
