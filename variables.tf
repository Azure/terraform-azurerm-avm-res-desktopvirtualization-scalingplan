variable "enable_telemetry" {
  type        = bool
  default     = true
  description = <<DESCRIPTION
This variable controls whether or not telemetry is enabled for the module.
For more information see https://aka.ms/avm/telemetryinfo.
If it is set to false, then no telemetry will be collected.
DESCRIPTION
}

# This is required for most resource modules
variable "resource_group_name" {
  type        = string
  description = "The resource group where the resources will be deployed."
}

variable "location" {
  type        = string
  description = "The Azure location where the resources will be deployed."
}

variable "name" {
  type        = string
  description = "The name of the AVD Scaling Plan."
  validation {
    condition     = can(regex("^[a-z0-9-]{3,24}$", var.name))
    error_message = "The name must be between 3 and 24 characters long and can only contain lowercase letters, numbers and dashes."
  }
}

variable "description" {
  type        = string
  description = "The description of the AVD Scaling Plan."
}

variable "time_zone" {
  type        = string
  description = "The time zone of the AVD Scaling Plan."
}

variable "schedule" {
  type = list(object({
    name                                 = string
    days_of_week                         = list(string)
    ramp_up_start_time                   = string
    ramp_up_load_balancing_algorithm     = string
    ramp_up_minimum_hosts_percent        = number
    ramp_up_capacity_threshold_percent   = number
    peak_start_time                      = string
    peak_load_balancing_algorithm        = string
    ramp_down_start_time                 = string
    ramp_down_load_balancing_algorithm   = string
    ramp_down_minimum_hosts_percent      = number
    ramp_down_force_logoff_users         = bool
    ramp_down_wait_time_minutes          = number
    ramp_down_notification_message       = string
    ramp_down_capacity_threshold_percent = number
    ramp_down_stop_hosts_when            = string
    off_peak_start_time                  = string
    off_peak_load_balancing_algorithm    = string
  }))

  validation {
    condition = alltrue(
      [
        for _, v in var.schedule :
        v.days_of_week != null || v.off_peak_start_time != null || v.off_peak_load_balancing_algorithm != null || v.ramp_down_capacity_threshold_percent != null || v.ramp_down_force_logoff_users != null || v.ramp_down_load_balancing_algorithm != null || v.ramp_down_minimum_hosts_percent != null || v.ramp_down_notification_message != null || v.ramp_down_start_time != null || v.ramp_down_stop_hosts_when != null || v.ramp_down_wait_time_minutes != null || v.ramp_up_capacity_threshold_percent != null || v.ramp_up_load_balancing_algorithm != null || v.ramp_up_minimum_hosts_percent != null || v.ramp_up_start_time != null
      ]
    )
    error_message = "At least one of `days_of_week`, `off_peak_start_time`, `off_peak_load_balancing_algorithm`, `ramp_down_capacity_threshold_percent`, `ramp_down_force_logoff_users`, `ramp_down_load_balancing_algorithm`, `ramp_down_minimum_hosts_percent`, `ramp_down_notification_message`, `ramp_down_start_time`, `ramp_down_stop_hosts_when`, `ramp_down_wait_time_minutes`, `ramp_up_capacity_threshold_percent`, `ramp_up_load_balancing_algorithm`, `ramp_up_minimum_hosts_percent`, or `ramp_up_start_time`, must be set."
  }
  description = <<DESCRIPTION
A map of schedules to create on AVD Scaling Plan. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time.

- `name` -  The name of the schedule.
- `days_of_week` -  The days of the week to apply the schedule to. 
- `off_peak_start_time` -  The start time of the off peak period. 
- `off_peak_load_balancing_algorithm` -  The load balancing algorithm to use during the off peak period. 
- `ramp_down_capacity_threshold_percent` -  The capacity threshold percentage to use during the ramp down period. 
- `ramp_down_force_logoff_users` -  Whether to force log off users during the ramp down period. 
- `ramp_down_load_balancing_algorithm` -  The load balancing algorithm to use during the ramp down period. 
- `ramp_down_minimum_hosts_percent` -  The minimum hosts percentage to use during the ramp down period. 
- `ramp_down_notification_message` -  The notification message to use during the ramp down period. 
- `ramp_down_start_time` -  The start time of the ramp down period. 
- `ramp_down_stop_hosts_when` -  When to stop hosts during the ramp down period. 
- `ramp_down_wait_time_minutes` -  The wait time in minutes to use during the ramp down period. 
- `peak_start_time` -  The start time of the peak period. 
- `peak_load_balancing_algorithm` -  The load balancing algorithm to use during the peak period. 
- `ramp_up_capacity_threshold_percent` - (Optional) The capacity threshold percentage to use during the ramp up period. 
- `ramp_up_load_balancing_algorithm` -  The load balancing algorithm to use during the ramp up period. 
- `ramp_up_minimum_hosts_percent` - (Optional) The minimum hosts percentage to use during the ramp up period. 
- `ramp_up_start_time` -  The start time of the ramp up period. 
DESCRIPTION
}


variable "hostpool" {
  type        = string
  description = "The name of the AVD Host Pool to assign the scaling plan to."
}

variable "tags" {
  type        = map(any)
  description = "Map of tags to assign to the Scaling Plan resource."
  default     = null
}

# tflint-ignore: terraform_unused_declarations
variable "tracing_tags_enabled" {
  type        = bool
  default     = false
  description = "Whether enable tracing tags that generated by BridgeCrew Yor."
  nullable    = false
}

# tflint-ignore: terraform_unused_declarations
variable "tracing_tags_prefix" {
  type        = string
  default     = "avm_"
  description = "Default prefix for generated tracing tags"
  nullable    = false
}

variable "lock" {
  type = object({
    name = optional(string, null)
    kind = optional(string, "None")
  })
  description = "The lock level to apply to the AVD Host Pool. Default is `ReadOnly`. Possible values are`Delete`, and `ReadOnly`."
  default     = {}
  nullable    = false
  validation {
    condition     = contains(["None", "Delete", "ReadOnly"], var.lock.kind)
    error_message = "The lock level must be one of: 'Delete', or 'ReadOnly'."
  }
}

variable "role_assignments" {
  type = map(object({
    role_definition_id_or_name             = string
    principal_id                           = string
    condition                              = string
    condition_version                      = string
    skip_service_principal_aad_check       = bool
    delegated_managed_identity_resource_id = string
  }))
  default     = {}
  description = <<DESCRIPTION
A map of role assignments to create on the AVD Host Pool. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time.

- `role_definition_id_or_name` - The ID or name of the role definition to assign to the principal.
- `principal_id` - The ID of the principal to assign the role to.
- `description` - The description of the role assignment.
- `skip_service_principal_aad_check` - If set to true, skips the Azure Active Directory check for the service principal in the tenant. Defaults to false.
- `condition` - The condition which will be used to scope the role assignment.
- `condition_version` - The version of the condition syntax. Valid values are '2.0'.

> Note: only set `skip_service_principal_aad_check` to true if you are assigning a role to a service principal.
DESCRIPTION
}

variable "diagnostic_settings" {
  type = map(object({
    name                                     = optional(string, null)
    log_categories                           = optional(set(string), [])
    log_groups                               = optional(set(string), ["allLogs"])
    workspace_resource_id                    = optional(string, null)
    storage_account_resource_id              = optional(string, null)
    event_hub_authorization_rule_resource_id = optional(string, null)
    event_hub_name                           = optional(string, null)
    marketplace_partner_resource_id          = optional(string, null)
  }))
  default  = {}
  nullable = false

  validation {
    condition = alltrue(
      [
        for _, v in var.diagnostic_settings :
        v.workspace_resource_id != null || v.storage_account_resource_id != null || v.event_hub_authorization_rule_resource_id != null || v.marketplace_partner_resource_id != null
      ]
    )
    error_message = "At least one of `workspace_resource_id`, `storage_account_resource_id`, `marketplace_partner_resource_id`, or `event_hub_authorization_rule_resource_id`, must be set."
  }
  description = <<DESCRIPTION
A map of diagnostic settings to create on the Key Vault. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time.

- `name` - (Optional) The name of the diagnostic setting. One will be generated if not set, however this will not be unique if you want to create multiple diagnostic setting resources.
- `log_categories` - (Optional) A set of log categories to send to the log analytics workspace. Defaults to `[]`.
- `log_groups` - (Optional) A set of log groups to send to the log analytics workspace. Defaults to `["allLogs"]`.
- `workspace_resource_id` - (Optional) The resource ID of the log analytics workspace to send logs and metrics to.
- `storage_account_resource_id` - (Optional) The resource ID of the storage account to send logs and metrics to.
- `event_hub_authorization_rule_resource_id` - (Optional) The resource ID of the event hub authorization rule to send logs and metrics to.
- `event_hub_name` - (Optional) The name of the event hub. If none is specified, the default event hub will be selected.
- `marketplace_partner_resource_id` - (Optional) The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic LogsLogs.
DESCRIPTION
}
