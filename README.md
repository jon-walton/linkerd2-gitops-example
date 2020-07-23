# GitOps Example

This is an example on deploying cluster resources using a GitOps pattern. This started as an experiment on deploying Linkerd2 with zero human interaction.

## Using the example

**Prerequisites**
- [Kind](https://kind.sigs.k8s.io/docs/user/quick-start/)
- [Terraform 0.12.x](https://releases.hashicorp.com/terraform/)
- [Kubectl](https://v1-16.docs.kubernetes.io/docs/tasks/tools/install-kubectl/)

**Create a Kind cluster**

```bash
kind create cluster --config ./cluster.yaml --wait 5m
```

**Deploy**

```bash
terraform apply ./terraform
```

Terraform does the following:
- Deploys Cert-Manager
- Creates a Linkerd trust anchor
    - Look at azure.tf to see how that could also be saved into a key vault
- Deploys a Cert-Manager issuer and a Linkerd identity certificate
- Deploys ingress-nginx
- Deploys ArgoCD
    - Bootstraps ArgoCD to monitor the `./argocd/environments` folder for applications to install
