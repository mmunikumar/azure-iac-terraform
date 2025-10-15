resource "azurerm_storage_account" "sa" {
  name                     = var.storage_account_name
  resource_group_name      = var.rg_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  # kind                     = "StorageV2"

  # allow_blob_public_access = false
  min_tls_version          = "TLS1_2"
  enable_https_traffic_only = true

  # Disable public network access - provider variations exist
  public_network_access_enabled = false

  network_rules {
    default_action = "Deny"
  }
}

resource "azurerm_private_dns_zone" "storage_blob" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = var.rg_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "storage_blob_link" {
  name                  = "link-${var.rg_name}-blob"
  resource_group_name   = var.rg_name
  private_dns_zone_name = azurerm_private_dns_zone.storage_blob.name
  virtual_network_id    = var.vnet_id
  depends_on            = [azurerm_private_dns_zone.storage_blob]
}

resource "azurerm_private_endpoint" "sa_pe_blob" {
  name                = "${var.storage_account_name}-blob-pe"
  resource_group_name = var.rg_name
  location            = var.location
  subnet_id           = var.endpoint_subnet_id

  private_service_connection {
    name                           = "${var.storage_account_name}-blob-psc"
    private_connection_resource_id = azurerm_storage_account.sa.id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name = "pdns-${var.storage_account_name}"
    private_dns_zone_ids = [
      azurerm_private_dns_zone.storage_blob.id
    ]
  }
}
