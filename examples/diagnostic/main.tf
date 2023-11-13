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

# This is the data source to get the host pool name
data "azurerm_virtual_desktop_host_pool" "name" {
  name                = var.host_pool
  resource_group_name = var.resource_group_name
}

# This is the module call
module "scplan" {
  source              = "../../"
  enable_telemetry    = var.enable_telemetry
  resource_group_name = data.azurerm_virtual_desktop_host_pool.name.resource_group_name
  location            = data.azurerm_virtual_desktop_host_pool.name.location
  scalingplan         = var.scalingplan
  hostpool            = data.azurerm_virtual_desktop_host_pool.name.name
  hostpooltype        = var.hostpooltype
  diagnostic_settings = {
    to_law = {
      name                        = "to-storage-account"
      storage_account_resource_id = var.storage_account_id
    }
  }
}
