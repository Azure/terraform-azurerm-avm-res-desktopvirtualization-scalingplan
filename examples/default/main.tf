terraform {
  required_version = ">= 1.0.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.7.0, < 4.0.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.5.0, < 4.0.0"
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
}
