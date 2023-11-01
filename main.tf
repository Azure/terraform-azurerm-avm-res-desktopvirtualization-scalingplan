# Terraform Docs: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_desktop_scaling_plan
data "azurerm_subscription" "current" {}

data "azurerm_client_config" "current" {}
data "azurerm_role_definition" "role" { # access an existing built-in role
  name = "Desktop Virtualization User"
}

# Get the Azure Virtual Desktop host pool
data "azurerm_virtual_desktop_host_pool" "this" {
  name                = var.hostpool
  resource_group_name = var.resource_group_name
}

data "azurerm_role_definition" "power_role" {
  name = "Desktop Virtualization Power On Off Contributor"
}

data "azuread_service_principal" "spn" {
  client_id = "9cdead84-a844-4324-93f2-b2e6bb768d07"
}

# autoscale settings scenario 1 https://docs.microsoft.com/azure/virtual-desktop/autoscale-scenarios
resource "azurerm_virtual_desktop_scaling_plan" "scplan" {
  name                = var.scalingplan
  location            = var.location
  resource_group_name = var.resource_group_name
  friendly_name       = "Scaling Plan Example"
  description         = "Scaling Plan"
  time_zone           = "Eastern Standard Time"
  tags                = var.tags
  schedule {
    name                                 = "Weekdays"
    days_of_week                         = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
    ramp_up_start_time                   = "05:00"
    ramp_up_load_balancing_algorithm     = "BreadthFirst"
    ramp_up_minimum_hosts_percent        = 30
    ramp_up_capacity_threshold_percent   = 30
    peak_start_time                      = "09:00"
    peak_load_balancing_algorithm        = "BreadthFirst"
    ramp_down_start_time                 = "19:00"
    ramp_down_load_balancing_algorithm   = "DepthFirst"
    ramp_down_minimum_hosts_percent      = 10
    ramp_down_force_logoff_users         = false
    ramp_down_wait_time_minutes          = 45
    ramp_down_notification_message       = "Please log off in the next 45 minutes..."
    ramp_down_capacity_threshold_percent = 5
    ramp_down_stop_hosts_when            = "ZeroSessions"
    off_peak_start_time                  = "22:00"
    off_peak_load_balancing_algorithm    = "DepthFirst"
  }
  schedule {
    name                                 = "Weekend"
    days_of_week                         = ["Saturday", "Sunday"]
    ramp_up_start_time                   = "09:00"
    ramp_up_load_balancing_algorithm     = "BreadthFirst"
    ramp_up_minimum_hosts_percent        = 30
    ramp_up_capacity_threshold_percent   = 10
    peak_start_time                      = "10:00"
    peak_load_balancing_algorithm        = "BreadthFirst"
    ramp_down_start_time                 = "16:00"
    ramp_down_load_balancing_algorithm   = "DepthFirst"
    ramp_down_minimum_hosts_percent      = 10
    ramp_down_force_logoff_users         = false
    ramp_down_wait_time_minutes          = 45
    ramp_down_notification_message       = "Please log of in the next 45 minutes..."
    ramp_down_capacity_threshold_percent = 5
    ramp_down_stop_hosts_when            = "ZeroSessions"
    off_peak_start_time                  = "20:00"
    off_peak_load_balancing_algorithm    = "DepthFirst"
  }
  host_pool {
    hostpool_id          = data.azurerm_virtual_desktop_host_pool.this.id
    scaling_plan_enabled = true
  }
}

resource "azurerm_role_assignment" "this" {
  for_each                               = var.role_assignments
  scope                                  = azurerm_virtual_desktop_scaling_plan.scplan.id
  role_definition_id                     = strcontains(lower(each.value.role_definition_id_or_name), lower(local.role_definition_resource_substring)) ? each.value.role_definition_id_or_name : null
  role_definition_name                   = strcontains(lower(each.value.role_definition_id_or_name), lower(local.role_definition_resource_substring)) ? null : each.value.role_definition_id_or_name
  principal_id                           = each.value.principal_id
  condition                              = each.value.condition
  condition_version                      = each.value.condition_version
  skip_service_principal_aad_check       = each.value.skip_service_principal_aad_check
  delegated_managed_identity_resource_id = each.value.delegated_managed_identity_resource_id
}

resource "azurerm_management_lock" "this" {
  count      = var.lock.kind != "None" ? 1 : 0
  name       = coalesce(var.lock.name, "lock-${var.scalingplan}")
  scope      = azurerm_virtual_desktop_scaling_plan.scplan.id
  lock_level = var.lock.kind
}


# Create Diagnostic Settings for AVD application group
resource "azurerm_monitor_diagnostic_setting" "this" {
  for_each                       = var.diagnostic_settings
  name                           = each.value.name != null ? each.value.name : "diag-${var.scalingplan}"
  target_resource_id             = azurerm_virtual_desktop_scaling_plan.scplan.id
  storage_account_id             = each.value.storage_account_resource_id
  eventhub_authorization_rule_id = each.value.event_hub_authorization_rule_resource_id
  eventhub_name                  = each.value.event_hub_name
  partner_solution_id            = each.value.marketplace_partner_resource_id
  log_analytics_workspace_id     = each.value.workspace_resource_id

  dynamic "enabled_log" {
    for_each = each.value.log_categories
    content {
      category = enabled_log.value
    }
  }

  dynamic "enabled_log" {
    for_each = each.value.log_groups
    content {
      category_group = enabled_log.value
    }
  }
}
