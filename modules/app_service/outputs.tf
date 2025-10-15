output "web_app_default_hostname" {
  value = azurerm_linux_web_app.webapp.default_hostname
}
output "web_app_id" {
  value = azurerm_linux_web_app.webapp.id
}
output "web_app_identity_principal_id" {
  value = azurerm_linux_web_app.webapp.identity[0].principal_id
}
