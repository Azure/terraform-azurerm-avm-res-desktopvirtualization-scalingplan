terraform {
  required_version = ">= 1.9, < 2.0"

  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = ">= 2.44.1, < 3.0.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.71, < 5.0.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.1.0, < 4.0.0"
    }
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

# This ensures we have unique CAF compliant names for our resources.
module "naming" {
  source  = "Azure/naming/azurerm"
  version = "0.3.0"
}

# This is required for resource modules
resource "azurerm_resource_group" "this" {
  location = "eastus"
  name     = module.naming.resource_group.name_unique
}



# This is the storage account for the diagnostic settings
resource "azurerm_storage_account" "storageaccount" {
  account_replication_type = "ZRS"
  account_tier             = "Standard"
  location                 = azurerm_resource_group.this.location
  name                     = module.naming.storage_account.name_unique
  resource_group_name      = azurerm_resource_group.this.name

  identity {
    type = "SystemAssigned"
  }
}

module "hostpool" {
  source  = "Azure/avm-res-desktopvirtualization-hostpool/azurerm"
  version = "0.2.0"

  resource_group_name                                = azurerm_resource_group.this.name
  virtual_desktop_host_pool_load_balancer_type       = "BreadthFirst"
  virtual_desktop_host_pool_location                 = azurerm_resource_group.this.location
  virtual_desktop_host_pool_name                     = "vdpool-avd-02"
  virtual_desktop_host_pool_resource_group_name      = azurerm_resource_group.this.name
  virtual_desktop_host_pool_type                     = "Pooled"
  enable_telemetry                                   = var.enable_telemetry
  virtual_desktop_host_pool_maximum_sessions_allowed = "16"
}

# Get the subscription
data "azurerm_subscription" "primary" {}

# Get the service principal for Azure Vitual Desktop
data "azuread_service_principal" "spn" {
  client_id = "9cdead84-a844-4324-93f2-b2e6bb768d07"
}

resource "random_uuid" "example" {}

data "azurerm_role_definition" "power_role" {
  name = "Desktop Virtualization Power On Off Contributor"
}

resource "azurerm_role_assignment" "new" {
  count = var.create_role_assignment ? 1 : 0

  principal_id                     = data.azuread_service_principal.spn.object_id
  scope                            = data.azurerm_subscription.primary.id
  name                             = random_uuid.example.result
  role_definition_id               = data.azurerm_role_definition.power_role.role_definition_id
  skip_service_principal_aad_check = true

  lifecycle {
    ignore_changes = all
  }
}


# This is the module call
module "scplan" {
  source = "../../"

  virtual_desktop_scaling_plan_location            = azurerm_resource_group.this.location
  virtual_desktop_scaling_plan_name                = "avdscalingplan"
  virtual_desktop_scaling_plan_resource_group_name = azurerm_resource_group.this.name
  virtual_desktop_scaling_plan_schedule = toset(
    [
      {
        name                                 = "Weekday"
        days_of_week                         = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
        ramp_up_start_time                   = "09:00"
        ramp_up_load_balancing_algorithm     = "BreadthFirst"
        ramp_up_minimum_hosts_percent        = 50
        ramp_up_capacity_threshold_percent   = 80
        peak_start_time                      = "10:00"
        peak_load_balancing_algorithm        = "BreadthFirst"
        ramp_down_start_time                 = "17:00"
        ramp_down_load_balancing_algorithm   = "BreadthFirst"
        ramp_down_minimum_hosts_percent      = 50
        ramp_down_force_logoff_users         = true
        ramp_down_wait_time_minutes          = 15
        ramp_down_notification_message       = "The session will end in 15 minutes."
        ramp_down_capacity_threshold_percent = 50
        ramp_down_stop_hosts_when            = "ZeroActiveSessions"
        off_peak_start_time                  = "18:00"
        off_peak_load_balancing_algorithm    = "BreadthFirst"
      },
      {
        name                                 = "Weekend"
        days_of_week                         = ["Saturday", "Sunday"]
        ramp_up_start_time                   = "09:00"
        ramp_up_load_balancing_algorithm     = "BreadthFirst"
        ramp_up_minimum_hosts_percent        = 50
        ramp_up_capacity_threshold_percent   = 80
        peak_start_time                      = "10:00"
        peak_load_balancing_algorithm        = "BreadthFirst"
        ramp_down_start_time                 = "17:00"
        ramp_down_load_balancing_algorithm   = "BreadthFirst"
        ramp_down_minimum_hosts_percent      = 50
        ramp_down_force_logoff_users         = true
        ramp_down_wait_time_minutes          = 15
        ramp_down_notification_message       = "The session will end in 15 minutes."
        ramp_down_capacity_threshold_percent = 50
        ramp_down_stop_hosts_when            = "ZeroActiveSessions"
        off_peak_start_time                  = "18:00"
        off_peak_load_balancing_algorithm    = "BreadthFirst"
      }
    ]
  )
  virtual_desktop_scaling_plan_time_zone = "Eastern Standard Time"
  diagnostic_settings = {
    to_law = {
      name                        = "to-storage-account"
      storage_account_resource_id = azurerm_storage_account.storageaccount.id
    }
  }
  enable_telemetry = var.enable_telemetry
  virtual_desktop_scaling_plan_host_pool = toset(
    [
      {
        hostpool_id          = module.hostpool.resource.id
        scaling_plan_enabled = true
      }
    ]
  )

  depends_on = [azurerm_resource_group.this, module.hostpool]
}
