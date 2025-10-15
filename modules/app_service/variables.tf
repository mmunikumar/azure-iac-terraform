variable "rg_name" {
  type = string
}

variable "location" {
  type = string
}

variable "app_service_plan_name" {
  type = string
}

variable "web_app_name" {
  type = string
}

variable "integration_subnet_id" {
  type = string
}

variable "endpoint_subnet_id" {
  type = string
}

variable "vnet_id" {
  type = string
}

variable "storage_account_id" {
  type = string
}

variable "key_vault_id" {
  type    = string
  default = ""
}
