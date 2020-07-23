//variable "azure_tenant_id" {
//  description = "The Azure tenant ID containing the subscription to create the resources"
//  type        = string
//}
//
//variable "azure_key_vault_region" {
//  description = "The Azure region to create the Key Vault resources"
//  type        = string
//}
//
//variable "azure_key_vault_resource_group_name" {
//  description = "The name of the resource group to contain the Key Vault"
//  type        = string
//}
//
//variable "azure_key_vault_name" {
//  description = "The name of the Key Vault"
//  type        = string
//}

variable "argocd_chart_version" {
  type    = string
  default = "2.5.4"
}

variable "cert_manager_version" {
  type    = string
  default = "0.15.2"
}

variable "ingress_nginx_version" {
  type    = string
  default = "2.11.1"
}

variable "linkerd_release" {
  description = "The release track for linkerd. Edge or Stable"
  type        = string
  default     = "stable"
}

variable "linkerd_version" {
  type    = string
  default = "2.8.1"
}
