terraform {
  required_version = ">= 1.0.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.7.0, < 4.0.0"
    }
    azapi = {
      source = "Azure/azapi"
    }
  }
}

provider "azurerm" {
  features {}
}

data "azurerm_virtual_desktop_host_pool" "this" {
  name                = var.host_pool
  resource_group_name = var.resource_group_name
}

resource "azurerm_resource_group" "qs101" {
  name     = "rg-qs101"
  location = "eastus"
}

resource "azapi_resource" "personalscplan" {
  type      = "Microsoft.DesktopVirtualization/scalingPlans@2022-10-14-preview"
  name      = "personalscplan"
  parent_id = azurerm_resource_group.qs101.id
  location  = "eastus"
  body = jsonencode({
    properties = {
      "friendlyName" : "personalscplan",
      "description" : "personalscplan",
      "hostPoolType" : "Personal",
      "timeZone" : "Eastern Standard Time",
      "exclusionTag" : "{}",
      "hostPoolReferences" : [
        {
          "hostPoolArmPath" : "${data.azurerm_virtual_desktop_host_pool.this.id}",
          "scalingPlanEnabled" : true
        }
      ],
    }
  })
}

