variable "resource_group_name" {
  type    = string
  default = "iac-rg"
}

variable "location" {
  type    = string
  default = "Southeast Asia"
}

variable "vnet_name" {
  type    = string
  default = "iac-vnet"
}

variable "vnet_address_space" {
  type    = list(string)
  default = ["10.0.0.0/16"]
}

variable "integration_subnet_prefix" {
  type    = string
  default = "10.0.1.0/24"
}

variable "endpoint_subnet_prefix" {
  type    = string
  default = "10.0.2.0/24"
}

variable "test_subnet_prefix" {
  type    = string
  default = "10.0.3.0/24"
}

variable "nsg_name" {
  type    = string
  default = "iac-nsg"
}

variable "storage_account_name" {
  type    = string
  default = "iacsaunique1"
}

variable "app_service_plan_name" {
  type    = string
  default = "iac-asp-unique1"
}

variable "web_app_name" {
  type    = string
  default = "iac-webapp-unique1"
}

variable "key_vault_name" {
  type    = string
  default = "iac-kv-unique1-test"
}
