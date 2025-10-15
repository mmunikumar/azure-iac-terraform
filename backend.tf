# Optional remote backend example. Uncomment and configure after creating the storage account for state.
# terraform {
#   backend "azurerm" {
#     resource_group_name  = "rg-state"
#     storage_account_name = "mystatestorageacct"
#     container_name       = "tfstate"
#     key                  = "prod.terraform.tfstate"
#   }
# }
