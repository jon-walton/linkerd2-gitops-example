${yamlencode({
  global = {
    identityTrustAnchorsPEM: "${identityTrustAnchorsPEM}"
  }

  installNamespace = false

  identity = {
    issuer = {
      scheme = "kubernetes.io/tls"
    }
  }
})}
