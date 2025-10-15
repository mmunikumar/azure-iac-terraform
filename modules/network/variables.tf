variable "rg_name" { type = string }
variable "location" { type = string }
variable "vnet_name" { type = string }
variable "vnet_address_space" { type = list(string) }
variable "integration_subnet_prefix" { type = string }
variable "endpoint_subnet_prefix" { type = string }
variable "test_subnet_prefix" { type = string }
variable "nsg_name" { type = string }
