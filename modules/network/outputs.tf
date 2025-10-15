output "vnet_id" { value = azurerm_virtual_network.this.id }
output "integration_subnet_id" { value = azurerm_subnet.integration.id }
output "endpoint_subnet_id" { value = azurerm_subnet.endpoint.id }
output "test_subnet_id" { value = azurerm_subnet.test.id }
