output "web_app_default_hostname" {
  value = module.app_service.web_app_default_hostname
}
output "storage_account_id" {
  value = module.storage.storage_account_id
}
output "vnet_id" {
  value = module.network.vnet_id
}
