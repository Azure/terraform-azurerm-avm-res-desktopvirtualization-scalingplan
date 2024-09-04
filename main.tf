# autoscale settings https://docs.microsoft.com/azure/virtual-desktop/autoscale-scenarios
resource "azurerm_virtual_desktop_scaling_plan" "this" {
  location            = var.virtual_desktop_scaling_plan_location
  name                = var.virtual_desktop_scaling_plan_name
  resource_group_name = var.virtual_desktop_scaling_plan_resource_group_name
  time_zone           = var.virtual_desktop_scaling_plan_time_zone
  description         = var.virtual_desktop_scaling_plan_description
  exclusion_tag       = var.virtual_desktop_scaling_plan_exclusion_tag
  friendly_name       = var.virtual_desktop_scaling_plan_friendly_name
  tags                = var.virtual_desktop_scaling_plan_tags

  dynamic "schedule" {
    for_each = var.virtual_desktop_scaling_plan_schedule

    content {
      days_of_week                         = schedule.value.days_of_week
      name                                 = schedule.value.name
      off_peak_load_balancing_algorithm    = schedule.value.off_peak_load_balancing_algorithm
      off_peak_start_time                  = schedule.value.off_peak_start_time
      peak_load_balancing_algorithm        = schedule.value.peak_load_balancing_algorithm
      peak_start_time                      = schedule.value.peak_start_time
      ramp_down_capacity_threshold_percent = schedule.value.ramp_down_capacity_threshold_percent
      ramp_down_force_logoff_users         = schedule.value.ramp_down_force_logoff_users
      ramp_down_load_balancing_algorithm   = schedule.value.ramp_down_load_balancing_algorithm
      ramp_down_minimum_hosts_percent      = schedule.value.ramp_down_minimum_hosts_percent
      ramp_down_notification_message       = schedule.value.ramp_down_notification_message
      ramp_down_start_time                 = schedule.value.ramp_down_start_time
      ramp_down_stop_hosts_when            = schedule.value.ramp_down_stop_hosts_when
      ramp_down_wait_time_minutes          = schedule.value.ramp_down_wait_time_minutes
      ramp_up_load_balancing_algorithm     = schedule.value.ramp_up_load_balancing_algorithm
      ramp_up_start_time                   = schedule.value.ramp_up_start_time
      ramp_up_capacity_threshold_percent   = schedule.value.ramp_up_capacity_threshold_percent
      ramp_up_minimum_hosts_percent        = schedule.value.ramp_up_minimum_hosts_percent
    }
  }
  dynamic "host_pool" {
    for_each = var.virtual_desktop_scaling_plan_host_pool == null ? [] : var.virtual_desktop_scaling_plan_host_pool

    content {
      hostpool_id          = host_pool.value.hostpool_id
      scaling_plan_enabled = host_pool.value.scaling_plan_enabled
    }
  }
  dynamic "timeouts" {
    for_each = var.virtual_desktop_scaling_plan_timeouts == null ? [] : [var.virtual_desktop_scaling_plan_timeouts]

    content {
      create = timeouts.value.create
      delete = timeouts.value.delete
      read   = timeouts.value.read
      update = timeouts.value.update
    }
  }
}

resource "azurerm_role_assignment" "this" {
  for_each = var.role_assignments

  principal_id                           = each.value.principal_id
  scope                                  = azurerm_virtual_desktop_scaling_plan.this.id
  condition                              = each.value.condition
  condition_version                      = each.value.condition_version
  delegated_managed_identity_resource_id = each.value.delegated_managed_identity_resource_id
  role_definition_id                     = strcontains(lower(each.value.role_definition_id_or_name), lower(local.role_definition_resource_substring)) ? each.value.role_definition_id_or_name : null
  role_definition_name                   = strcontains(lower(each.value.role_definition_id_or_name), lower(local.role_definition_resource_substring)) ? null : each.value.role_definition_id_or_name
  skip_service_principal_aad_check       = each.value.skip_service_principal_aad_check
}

# Create Diagnostic Settings for AVD application group
resource "azurerm_monitor_diagnostic_setting" "this" {
  for_each = var.diagnostic_settings

  name                           = each.value.name != null ? each.value.name : "diag-${var.virtual_desktop_scaling_plan_name}"
  target_resource_id             = azurerm_virtual_desktop_scaling_plan.this.id
  eventhub_authorization_rule_id = each.value.event_hub_authorization_rule_resource_id
  eventhub_name                  = each.value.event_hub_name
  log_analytics_workspace_id     = each.value.workspace_resource_id
  partner_solution_id            = each.value.marketplace_partner_resource_id
  storage_account_id             = each.value.storage_account_resource_id

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


# required AVM resources interfaces
resource "azurerm_management_lock" "this" {
  count = var.lock != null ? 1 : 0

  lock_level = var.lock.kind
  name       = coalesce(var.lock.name, "lock-${var.lock.kind}")
  scope      = azurerm_virtual_desktop_scaling_plan.this.id
  notes      = var.lock.kind == "CanNotDelete" ? "Cannot delete the resource or its child resources." : "Cannot delete or modify the resource or its child resources."
}
