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
  skip_provider_registration = true
}

# Resource Group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

# Modules
module "network" {
  source                    = "./modules/network"
  rg_name                   = azurerm_resource_group.rg.name
  location                  = azurerm_resource_group.rg.location
  vnet_name                 = var.vnet_name
  vnet_address_space        = var.vnet_address_space
  integration_subnet_prefix = var.integration_subnet_prefix
  endpoint_subnet_prefix    = var.endpoint_subnet_prefix
  test_subnet_prefix        = var.test_subnet_prefix
  nsg_name                  = var.nsg_name
}

module "storage" {
  source               = "./modules/storage"
  rg_name              = azurerm_resource_group.rg.name
  location             = azurerm_resource_group.rg.location
  storage_account_name = var.storage_account_name
  vnet_id              = module.network.vnet_id
  endpoint_subnet_id   = module.network.endpoint_subnet_id
}

module "keyvault" {
  source             = "./modules/keyvault"
  rg_name            = azurerm_resource_group.rg.name
  location           = azurerm_resource_group.rg.location
  key_vault_name     = var.key_vault_name
  vnet_id            = module.network.vnet_id
  endpoint_subnet_id = module.network.endpoint_subnet_id
}

module "app_service" {
  source                = "./modules/app_service"
  rg_name               = azurerm_resource_group.rg.name
  location              = azurerm_resource_group.rg.location
  app_service_plan_name = var.app_service_plan_name
  web_app_name          = var.web_app_name
  integration_subnet_id = module.network.integration_subnet_id
  endpoint_subnet_id    = module.network.endpoint_subnet_id
  vnet_id               = module.network.vnet_id
  storage_account_id    = module.storage.storage_account_id
  key_vault_id          = module.keyvault.key_vault_id
}
