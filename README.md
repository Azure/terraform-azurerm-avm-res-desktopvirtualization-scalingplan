<!-- BEGIN_TF_DOCS -->
# terraform-azurerm-avm-res-desktopvirtualization-scalingplans

[![Average time to resolve an issue](http://isitmaintained.com/badge/resolution/Azure/terraform-azurerm-avm-res-desktopvirtualization-scalingplan.svg)](http://isitmaintained.com/project/Azure/terraform-azurerm-avm-res-desktopvirtualization-scalingplan "Average time to resolve an issue")
[![Percentage of issues still open](http://isitmaintained.com/badge/open/Azure/terraform-azurerm-avm-res-desktopvirtualization-scalingplan.svg)](http://isitmaintained.com/project/Azure/terraform-azurerm-avm-res-desktopvirtualization-scalingplan "Percentage of issues still open")

Module to deploy Azure Virtual Desktop Scaling Plan and associated resources.

## Features
- Azure Virtual Desktop Scaling Plan
  - Host Pool assignments
  - Schedules

<!-- markdownlint-disable MD033 -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>= 1.6.6, < 2.0.0)

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (>= 3.11.1, < 4.0.0)

- <a name="requirement_modtm"></a> [modtm](#requirement\_modtm) (~> 0.3)

- <a name="requirement_random"></a> [random](#requirement\_random) (>= 3.5.1, < 4.0.0)


## Providers

The following providers are used by this module:

- <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) (>= 3.11.1, < 4.0.0)

- <a name="provider_modtm"></a> [modtm](#provider\_modtm) (~> 0.3)

- <a name="provider_random"></a> [random](#provider\_random) (>= 3.5.1, < 4.0.0)


## Resources

The following resources are used by this module:

- [azurerm_management_lock.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/management_lock) (resource)
- [azurerm_monitor_diagnostic_setting.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) (resource)
- [azurerm_role_assignment.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) (resource)
- [azurerm_virtual_desktop_scaling_plan.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_desktop_scaling_plan) (resource)
- [modtm_telemetry.telemetry](https://registry.terraform.io/providers/hashicorp/modtm/latest/docs/resources/telemetry) (resource)
- [random_uuid.telemetry](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/uuid) (resource)
- [azurerm_client_config.telemetry](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) (data source)
- [modtm_module_source.telemetry](https://registry.terraform.io/providers/hashicorp/modtm/latest/docs/data-sources/module_source) (data source)


<!-- markdownlint-disable MD013 -->
## Required Inputs

The following input variables are required:

### <a name="input_virtual_desktop_scaling_plan_location"></a> [virtual\_desktop\_scaling\_plan\_location](#input\_virtual\_desktop\_scaling\_plan\_location)

Description: (Required) The Azure Region where the Virtual Desktop Scaling Plan should exist. Changing this forces a new Virtual Desktop Scaling Plan to be created.

Type: `string`

### <a name="input_virtual_desktop_scaling_plan_name"></a> [virtual\_desktop\_scaling\_plan\_name](#input\_virtual\_desktop\_scaling\_plan\_name)

Description: (Required) The name which should be used for this Virtual Desktop Scaling Plan . Changing this forces a new Virtual Desktop Scaling Plan to be created.

Type: `string`

### <a name="input_virtual_desktop_scaling_plan_resource_group_name"></a> [virtual\_desktop\_scaling\_plan\_resource\_group\_name](#input\_virtual\_desktop\_scaling\_plan\_resource\_group\_name)

Description: (Required) The name of the Resource Group where the Virtual Desktop Scaling Plan should exist. Changing this forces a new Virtual Desktop Scaling Plan to be created.

Type: `string`

### <a name="input_virtual_desktop_scaling_plan_schedule"></a> [virtual\_desktop\_scaling\_plan\_schedule](#input\_virtual\_desktop\_scaling\_plan\_schedule)

Description: - `days_of_week` - (Required) A list of Days of the Week on which this schedule will be used. Possible values are `Monday`, `Tuesday`, `Wednesday`, `Thursday`, `Friday`, `Saturday`, and `Sunday`
- `name` - (Required) The name of the schedule.
- `off_peak_load_balancing_algorithm` - (Required) The load Balancing Algorithm to use during Off-Peak Hours. Possible values are `DepthFirst` and `BreadthFirst`.
- `off_peak_start_time` - (Required) The time at which Off-Peak scaling will begin. This is also the end-time for the Ramp-Down period. The time must be specified in "HH:MM" format.
- `peak_load_balancing_algorithm` - (Required) The load Balancing Algorithm to use during Peak Hours. Possible values are `DepthFirst` and `BreadthFirst`.
- `peak_start_time` - (Required) The time at which Peak scaling will begin. This is also the end-time for the Ramp-Up period. The time must be specified in "HH:MM" format.
- `ramp_down_capacity_threshold_percent` - (Required) This is the value in percentage of used host pool capacity that will be considered to evaluate whether to turn on/off virtual machines during the ramp-down and off-peak hours. For example, if capacity threshold is specified as 60% and your total host pool capacity is 100 sessions, autoscale will turn on additional session hosts once the host pool exceeds a load of 60 sessions.
- `ramp_down_force_logoff_users` - (Required) Whether users will be forced to log-off session hosts once the `ramp_down_wait_time_minutes` value has been exceeded during the Ramp-Down period. Possible
- `ramp_down_load_balancing_algorithm` - (Required) The load Balancing Algorithm to use during the Ramp-Down period. Possible values are `DepthFirst` and `BreadthFirst`.
- `ramp_down_minimum_hosts_percent` - (Required) The minimum percentage of session host virtual machines that you would like to get to for ramp-down and off-peak hours. For example, if Minimum percentage of hosts is specified as 10% and total number of session hosts in your host pool is 10, autoscale will ensure a minimum of 1 session host is available to take user connections.
- `ramp_down_notification_message` - (Required) The notification message to send to users during Ramp-Down period when they are required to log-off.
- `ramp_down_start_time` - (Required) The time at which Ramp-Down scaling will begin. This is also the end-time for the Ramp-Up period. The time must be specified in "HH:MM" format.
- `ramp_down_stop_hosts_when` - (Required) Controls Session Host shutdown behaviour during Ramp-Down period. Session Hosts can either be shutdown when all sessions on the Session Host have ended, or when there are no Active sessions left on the Session Host. Possible values are `ZeroSessions` and `ZeroActiveSessions`.
- `ramp_down_wait_time_minutes` - (Required) The number of minutes during Ramp-Down period that autoscale will wait after setting the session host VMs to drain mode, notifying any currently signed in users to save their work before forcing the users to logoff. Once all user sessions on the session host VM have been logged off, Autoscale will shut down the VM.
- `ramp_up_capacity_threshold_percent` - (Optional) This is the value of percentage of used host pool capacity that will be considered to evaluate whether to turn on/off virtual machines during the ramp-up and peak hours. For example, if capacity threshold is specified as `60%` and your total host pool capacity is `100` sessions, autoscale will turn on additional session hosts once the host pool exceeds a load of `60` sessions.
- `ramp_up_load_balancing_algorithm` - (Required) The load Balancing Algorithm to use during the Ramp-Up period. Possible values are `DepthFirst` and `BreadthFirst`.
- `ramp_up_minimum_hosts_percent` - (Optional) Specifies the minimum percentage of session host virtual machines to start during ramp-up for peak hours. For example, if Minimum percentage of hosts is specified as `10%` and total number of session hosts in your host pool is `10`, autoscale will ensure a minimum of `1` session host is available to take user connections.
- `ramp_up_start_time` - (Required) The time at which Ramp-Up scaling will begin. This is also the end-time for the Ramp-Up period. The time must be specified in "HH:MM" format.

Type:

```hcl
list(object({
    days_of_week                         = set(string)
    name                                 = string
    off_peak_load_balancing_algorithm    = string
    off_peak_start_time                  = string
    peak_load_balancing_algorithm        = string
    peak_start_time                      = string
    ramp_down_capacity_threshold_percent = number
    ramp_down_force_logoff_users         = bool
    ramp_down_load_balancing_algorithm   = string
    ramp_down_minimum_hosts_percent      = number
    ramp_down_notification_message       = string
    ramp_down_start_time                 = string
    ramp_down_stop_hosts_when            = string
    ramp_down_wait_time_minutes          = number
    ramp_up_capacity_threshold_percent   = optional(number)
    ramp_up_load_balancing_algorithm     = string
    ramp_up_minimum_hosts_percent        = optional(number)
    ramp_up_start_time                   = string
  }))
```

### <a name="input_virtual_desktop_scaling_plan_time_zone"></a> [virtual\_desktop\_scaling\_plan\_time\_zone](#input\_virtual\_desktop\_scaling\_plan\_time\_zone)

Description: (Required) Specifies the Time Zone which should be used by the Scaling Plan for time based events, [the possible values are defined here](https://jackstromberg.com/2017/01/list-of-time-zones-consumed-by-azure/).

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_diagnostic_settings"></a> [diagnostic\_settings](#input\_diagnostic\_settings)

Description: A map of diagnostic settings to create on the Key Vault. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time.

- `name` - (Optional) The name of the diagnostic setting. One will be generated if not set, however this will not be unique if you want to create multiple diagnostic setting resources.
- `log_categories` - (Optional) A set of log categories to send to the log analytics workspace. Defaults to `[]`.
- `log_groups` - (Optional) A set of log groups to send to the log analytics workspace. Defaults to `["allLogs"]`.
- `metric_categories` - (Optional) A set of metric categories to send to the log analytics workspace. Defaults to `["AllMetrics"]`.
- `log_analytics_destination_type` - (Optional) The destination type for the diagnostic setting. Possible values are `Dedicated` and `AzureDiagnostics`. Defaults to `Dedicated`.
- `workspace_resource_id` - (Optional) The resource ID of the log analytics workspace to send logs and metrics to.
- `storage_account_resource_id` - (Optional) The resource ID of the storage account to send logs and metrics to.
- `event_hub_authorization_rule_resource_id` - (Optional) The resource ID of the event hub authorization rule to send logs and metrics to.
- `event_hub_name` - (Optional) The name of the event hub. If none is specified, the default event hub will be selected.
- `marketplace_partner_resource_id` - (Optional) The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic LogsLogs.

Type:

```hcl
map(object({
    name                                     = optional(string, null)
    log_categories                           = optional(set(string), [])
    log_groups                               = optional(set(string), ["allLogs"])
    metric_categories                        = optional(set(string), ["AllMetrics"])
    log_analytics_destination_type           = optional(string, "Dedicated")
    workspace_resource_id                    = optional(string, null)
    storage_account_resource_id              = optional(string, null)
    event_hub_authorization_rule_resource_id = optional(string, null)
    event_hub_name                           = optional(string, null)
    marketplace_partner_resource_id          = optional(string, null)
  }))
```

Default: `{}`

### <a name="input_enable_telemetry"></a> [enable\_telemetry](#input\_enable\_telemetry)

Description: This variable controls whether or not telemetry is enabled for the module.  
For more information see <https://aka.ms/avm/telemetryinfo>.  
If it is set to false, then no telemetry will be collected.

Type: `bool`

Default: `true`

### <a name="input_lock"></a> [lock](#input\_lock)

Description:   Controls the Resource Lock configuration for this resource. The following properties can be specified:

  - `kind` - (Required) The type of lock. Possible values are `\"CanNotDelete\"` and `\"ReadOnly\"`.
  - `name` - (Optional) The name of the lock. If not specified, a name will be generated based on the `kind` value. Changing this forces the creation of a new resource.

Type:

```hcl
object({
    kind = string
    name = optional(string, null)
  })
```

Default: `null`

### <a name="input_role_assignments"></a> [role\_assignments](#input\_role\_assignments)

Description:   A map of role assignments to create on the resource. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time.

  - `role_definition_id_or_name` - The ID or name of the role definition to assign to the principal.
  - `principal_id` - The ID of the principal to assign the role to.
  - `description` - The description of the role assignment.
  - `skip_service_principal_aad_check` - If set to true, skips the Azure Active Directory check for the service principal in the tenant. Defaults to false.
  - `condition` - The condition which will be used to scope the role assignment.
  - `condition_version` - The version of the condition syntax. Leave as `null` if you are not using a condition, if you are then valid values are '2.0'.

  > Note: only set `skip_service_principal_aad_check` to true if you are assigning a role to a service principal.

Type:

```hcl
map(object({
    role_definition_id_or_name             = string
    principal_id                           = string
    description                            = optional(string, null)
    skip_service_principal_aad_check       = optional(bool, false)
    condition                              = optional(string, null)
    condition_version                      = optional(string, null)
    delegated_managed_identity_resource_id = optional(string, null)
    principal_type                         = optional(string, null)
  }))
```

Default: `{}`

### <a name="input_virtual_desktop_scaling_plan_description"></a> [virtual\_desktop\_scaling\_plan\_description](#input\_virtual\_desktop\_scaling\_plan\_description)

Description: (Optional) A description of the Scaling Plan.

Type: `string`

Default: `null`

### <a name="input_virtual_desktop_scaling_plan_exclusion_tag"></a> [virtual\_desktop\_scaling\_plan\_exclusion\_tag](#input\_virtual\_desktop\_scaling\_plan\_exclusion\_tag)

Description: (Optional) The name of the tag associated with the VMs you want to exclude from autoscaling.

Type: `string`

Default: `null`

### <a name="input_virtual_desktop_scaling_plan_friendly_name"></a> [virtual\_desktop\_scaling\_plan\_friendly\_name](#input\_virtual\_desktop\_scaling\_plan\_friendly\_name)

Description: (Optional) Friendly name of the Scaling Plan.

Type: `string`

Default: `null`

### <a name="input_virtual_desktop_scaling_plan_host_pool"></a> [virtual\_desktop\_scaling\_plan\_host\_pool](#input\_virtual\_desktop\_scaling\_plan\_host\_pool)

Description: - `hostpool_id` - (Required) The ID of the HostPool to assign the Scaling Plan to.
- `scaling_plan_enabled` - (Required) Specifies if the scaling plan is enabled or disabled for the HostPool.

Type:

```hcl
list(object({
    hostpool_id          = string
    scaling_plan_enabled = bool
  }))
```

Default: `null`

### <a name="input_virtual_desktop_scaling_plan_tags"></a> [virtual\_desktop\_scaling\_plan\_tags](#input\_virtual\_desktop\_scaling\_plan\_tags)

Description: (Optional) A mapping of tags which should be assigned to the Virtual Desktop Scaling Plan .

Type: `map(string)`

Default: `null`

### <a name="input_virtual_desktop_scaling_plan_timeouts"></a> [virtual\_desktop\_scaling\_plan\_timeouts](#input\_virtual\_desktop\_scaling\_plan\_timeouts)

Description: - `create` - (Defaults to 1 hour) Used when creating the Virtual Desktop Scaling Plan.
- `delete` - (Defaults to 1 hour) Used when deleting the Virtual Desktop Scaling Plan.
- `read` - (Defaults to 5 minutes) Used when retrieving the Virtual Desktop Scaling Plan.
- `update` - (Defaults to 1 hour) Used when updating the Virtual Desktop Scaling Plan.

Type:

```hcl
object({
    create = optional(string)
    delete = optional(string)
    read   = optional(string)
    update = optional(string)
  })
```

Default: `null`

## Outputs

The following outputs are exported:

### <a name="output_resource"></a> [resource](#output\_resource)

Description: This output is the full output for the resource to allow flexibility to reference all possible values for the resource. Example usage: module.<modulename>.resource.id

### <a name="output_resource_id"></a> [resource\_id](#output\_resource\_id)

Description: This output is the full output for the resource to allow flexibility to reference all possible values for the resource. Example usage: module.<modulename>.resource.id

## Modules

No modules.

<!-- markdownlint-disable-next-line MD041 -->
## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the repository. There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
<!-- END_TF_DOCS -->