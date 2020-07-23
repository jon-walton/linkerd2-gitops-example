terraform {
  required_version = "~> 0.12.0"
  required_providers {
    azuread    = "~> 0.11.0"
    azurerm    = "~> 2.19.0"
    github     = "~> 2.9.0"
    helm       = "~> 1.2.4"
    kubernetes = "~> 1.11.0"
    local      = "~> 1.4.0"
    tls        = "~> 2.1.0"
  }

  //  It's best to save the Terraform state in a secure & encrypted backend
  //  backend "azurerm" {}
}

provider "azurerm" {
  //  When running in CI:
  //   Use environment vars for the provider config
  //   https://www.terraform.io/docs/providers/azurerm/index.html#argument-reference
  features {}
}

provider "github" {
  //  When running in CI:
  //   Use environment vars for the provider config
  //   https://www.terraform.io/docs/providers/github/index.html#argument-reference
}

provider "helm" {}

//  See https://www.hashicorp.com/blog/deploy-any-resource-with-the-new-kubernetes-provider-for-hashicorp-terraform/
//    on how to install it
//provider "kubernetes-alpha" {
//  //  When running in CI:
//  //    Use environment vars for the provider config
//  //    https://github.com/hashicorp/terraform-provider-kubernetes-alpha/blob/master/docs/usage.md
//  config_path          = "~/.kube/config"
//  config_context       = "kind-kind"
//  server_side_planning = false
//}

provider "kubernetes" {
  //  When running in CI:
  //   Set `load_config_file` to false, clear `config_context`.
  //   Use environment vars for the provider config.
  //   https://www.terraform.io/docs/providers/kubernetes/index.html#argument-reference
  load_config_file = true
  config_context   = "kind-kind"
}

