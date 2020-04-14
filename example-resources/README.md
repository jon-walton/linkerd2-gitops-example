# Note

In a real deployment, this folder will not contain any private keys. Having the private key here makes it easier to deal with the example. It's only used to bootstrap the secret used by cert-manager to sign new certificates using our supplied ca cert.

Automation _could_ add CA public keys here for Linkerd to pick up in it's deployment. I tried that but couldn't get ArgoCD to take it for now :(
