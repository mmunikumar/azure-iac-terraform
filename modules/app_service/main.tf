terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.80.0"
    }
  }

  required_version = ">= 1.3.0"
}

provider "azurerm" {
  features {}

  # Enable this only if provider registration is restricted by org policy
  skip_provider_registration = true
}

# -----------------------------------------------------
# Data Sources
# -----------------------------------------------------
data "azurerm_client_config" "current" {}

# -----------------------------------------------------
# Service Plan
# -----------------------------------------------------
resource "azurerm_service_plan" "plan" {
  name                = var.app_service_plan_name
  location            = var.location
  resource_group_name = var.rg_name
  os_type             = "Linux"
  sku_name            = "B1"

#  tags = {
#    Environment = var.environment
#  }
}

# -----------------------------------------------------
# Linux Web App (Private Only)
# -----------------------------------------------------
resource "azurerm_linux_web_app" "webapp" {
  name                = var.web_app_name
  location            = var.location
  resource_group_name = var.rg_name
  service_plan_id     = azurerm_service_plan.plan.id

  https_only                    = true
  public_network_access_enabled = false

  identity {
    type = "SystemAssigned"
  }

  site_config {
    vnet_route_all_enabled = true
    ftps_state             = "Disabled"
    always_on              = true
  }

  # Optionally deploy a simple default HTML page
  app_settings = {
    "WEBSITE_RUN_FROM_PACKAGE" = "1"
    "APPINSIGHTS_INSTRUMENTATIONKEY" = ""
  }

  depends_on = [
    azurerm_service_plan.plan
  ]

#  tags = {
#    Environment = var.environment
#  }
}

# -----------------------------------------------------
# Private DNS Zone for Web App
# -----------------------------------------------------
resource "azurerm_private_dns_zone" "app" {
  name                = "privatelink.azurewebsites.net"
  resource_group_name = var.rg_name
}

# Link DNS Zone ↔ VNet
resource "azurerm_private_dns_zone_virtual_network_link" "app_link" {
  name                  = "app-link"
  resource_group_name   = var.rg_name
  private_dns_zone_name = azurerm_private_dns_zone.app.name
  virtual_network_id    = var.vnet_id
  registration_enabled  = false

  depends_on = [
    azurerm_private_dns_zone.app
  ]
}

# -----------------------------------------------------
# Private Endpoint for Web App
# -----------------------------------------------------
resource "azurerm_private_endpoint" "webapp_pe" {
  name                = "${var.web_app_name}-pe"
  resource_group_name = var.rg_name
  location            = var.location
  subnet_id           = var.endpoint_subnet_id

  private_service_connection {
    name                           = "${var.web_app_name}-psc"
    private_connection_resource_id = azurerm_linux_web_app.webapp.id
    subresource_names              = ["sites"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "webapp-dns"
    private_dns_zone_ids = [azurerm_private_dns_zone.app.id]
  }

  depends_on = [
    azurerm_linux_web_app.webapp,
    azurerm_private_dns_zone.app,
    azurerm_private_dns_zone_virtual_network_link.app_link
  ]
}

# -----------------------------------------------------
# VNet Integration (Swift Connection)
# -----------------------------------------------------
resource "azurerm_app_service_virtual_network_swift_connection" "vnet_integration" {
  app_service_id = azurerm_linux_web_app.webapp.id
  subnet_id      = var.integration_subnet_id

  depends_on = [
    azurerm_linux_web_app.webapp,
    azurerm_private_endpoint.webapp_pe
  ]
}

# -----------------------------------------------------
# Key Vault Access Policy for Web App's Managed Identity
# -----------------------------------------------------
resource "azurerm_key_vault_access_policy" "grant_webapp" {
  key_vault_id = var.key_vault_id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_linux_web_app.webapp.identity[0].principal_id

  secret_permissions = ["Get", "List"]

  depends_on = [
    azurerm_linux_web_app.webapp
  ]
}
