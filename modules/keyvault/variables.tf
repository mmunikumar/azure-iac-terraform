variable "rg_name" {
  type        = string
  description = "Name of the Azure Resource Group"
}

variable "location" {
  type        = string
  description = "Azure region where resources will be deployed"
}

variable "key_vault_name" {
  type        = string
  description = "Name of the Azure Key Vault"
}

variable "vnet_id" {
  type        = string
  description = "ID of the Virtual Network used in private DNS and endpoints"
}

variable "endpoint_subnet_id" {
  type        = string
  description = "ID of the subnet to deploy the private endpoint into"
}
