//data "azuread_client_config" "current" {}
//
//resource "azurerm_resource_group" "key_vault" {
//  location = var.azure_key_vault_region
//  name     = var.azure_key_vault_resource_group_name
//}
//
//resource "azurerm_key_vault" "linkerd" {
//  tenant_id           = var.azure_tenant_id
//  location            = var.azure_key_vault_region
//  name                = var.azure_key_vault_name
//  resource_group_name = azurerm_resource_group.key_vault.name
//  sku_name            = "standard"
//
//  access_policy {
//    tenant_id = var.azure_tenant_id
//    object_id = data.azuread_client_config.current.object_id
//
//    secret_permissions = [
//      "get",
//      "set",
//      "list",
//      "delete"
//    ]
//  }
//}
//
//resource "azurerm_key_vault_secret" "linkerd_trust_anchor_cert_pem" {
//  key_vault_id = azurerm_key_vault.linkerd.id
//  name         = "linkerd_trust_anchor_cert_pem"
//  value        = base64encode(tls_self_signed_cert.linkerd_trust_anchor.cert_pem)
//}
//
//resource "azurerm_key_vault_secret" "linkerd_trust_anchor_private_key_pem" {
//  key_vault_id = azurerm_key_vault.linkerd.id
//  name         = "linkerd_trust_anchor_private_key_pem"
//  value        = base64encode(tls_private_key.linkerd_trust_anchor.private_key_pem)
//}
