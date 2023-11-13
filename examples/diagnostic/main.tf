terraform {
  required_version = ">= 1.0.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.7.0, < 4.0.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# This ensures we have unique CAF compliant names for our resources.
module "naming" {
  source  = "Azure/naming/azurerm"
  version = "0.3.0"
}

# This is the data source to get the host pool name
data "azurerm_virtual_desktop_host_pool" "name" {
  name                = var.host_pool
  resource_group_name = var.resource_group_name
}

// This is the storage account for the diagnostic settings
resource "azurerm_storage_account" "this" {
  name                     = module.naming.storage_account.name_unique
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# This is the module call
module "scplan" {
  source              = "../../"
  enable_telemetry    = var.enable_telemetry
  resource_group_name = data.azurerm_virtual_desktop_host_pool.name.resource_group_name
  location            = data.azurerm_virtual_desktop_host_pool.name.location
  scalingplan         = var.scalingplan
  hostpool            = data.azurerm_virtual_desktop_host_pool.name.name
  diagnostic_settings = {
    to_law = {
      name                        = "to-storage-account"
      storage_account_resource_id = azurerm_storage_account.this.id
    }
  }
}
