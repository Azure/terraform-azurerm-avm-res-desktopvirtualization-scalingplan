<!-- BEGIN_TF_DOCS -->
# terraform-azurerm-avm-res-desktopvirtualization-scalingplan

Terraform Azure Verified Modules for deploying Azure Virtual Desktop Scaling Plan

<!-- markdownlint-disable MD033 -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>= 1.0.0)

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (>= 3.71.0)

- <a name="requirement_random"></a> [random](#requirement\_random) (>= 3.5.0)

## Providers

The following providers are used by this module:

- <a name="provider_azuread"></a> [azuread](#provider\_azuread)

- <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) (>= 3.71.0)

- <a name="provider_random"></a> [random](#provider\_random) (>= 3.5.0)

## Resources

The following resources are used by this module:

- [azurerm_management_lock.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/management_lock) (resource)
- [azurerm_monitor_diagnostic_setting.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) (resource)
- [azurerm_resource_group_template_deployment.telemetry](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group_template_deployment) (resource)
- [azurerm_role_assignment.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) (resource)
- [azurerm_virtual_desktop_scaling_plan.scplan](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_desktop_scaling_plan) (resource)
- [random_id.telem](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) (resource)
- [azuread_service_principal.spn](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/service_principal) (data source)
- [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) (data source)
- [azurerm_role_definition.power_role](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/role_definition) (data source)
- [azurerm_role_definition.role](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/role_definition) (data source)
- [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) (data source)
- [azurerm_virtual_desktop_host_pool.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/virtual_desktop_host_pool) (data source)

<!-- markdownlint-disable MD013 -->
## Required Inputs

The following input variables are required:

### <a name="input_hostpool"></a> [hostpool](#input\_hostpool)

Description: The name of the AVD Host Pool to assign the application group to.

Type: `string`

### <a name="input_hostpooltype"></a> [hostpooltype](#input\_hostpooltype)

Description: The type of the AVD Host Pool to assign the scaling plan.

Type: `string`

### <a name="input_location"></a> [location](#input\_location)

Description: The Azure location where the resources will be deployed.

Type: `string`

### <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name)

Description: The resource group where the resources will be deployed.

Type: `string`

### <a name="input_scalingplan"></a> [scalingplan](#input\_scalingplan)

Description: The name of the AVD Application Group.

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_diagnostic_settings"></a> [diagnostic\_settings](#input\_diagnostic\_settings)

Description: A map of diagnostic settings to create on the Key Vault. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time.

- `name` - (Optional) The name of the diagnostic setting. One will be generated if not set, however this will not be unique if you want to create multiple diagnostic setting resources.
- `log_categories` - (Optional) A set of log categories to send to the log analytics workspace. Defaults to `[]`.
- `log_groups` - (Optional) A set of log groups to send to the log analytics workspace. Defaults to `["allLogs"]`.
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
For more information see https://aka.ms/avm/telemetryinfo.  
If it is set to false, then no telemetry will be collected.

Type: `bool`

Default: `true`

### <a name="input_lock"></a> [lock](#input\_lock)

Description: The lock level to apply to the AVD Host Pool. Default is `ReadOnly`. Possible values are`Delete`, and `ReadOnly`.

Type:

```hcl
object({
    name = optional(string, null)
    kind = optional(string, "None")
  })
```

Default: `{}`

### <a name="input_role_assignments"></a> [role\_assignments](#input\_role\_assignments)

Description: A map of role assignments to create on the AVD Host Pool. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time.

- `role_definition_id_or_name` - The ID or name of the role definition to assign to the principal.
- `principal_id` - The ID of the principal to assign the role to.
- `description` - The description of the role assignment.
- `skip_service_principal_aad_check` - If set to true, skips the Azure Active Directory check for the service principal in the tenant. Defaults to false.
- `condition` - The condition which will be used to scope the role assignment.
- `condition_version` - The version of the condition syntax. Valid values are '2.0'.

> Note: only set `skip_service_principal_aad_check` to true if you are assigning a role to a service principal.

Type:

```hcl
map(object({
    role_definition_id_or_name             = string
    principal_id                           = string
    condition                              = string
    condition_version                      = string
    skip_service_principal_aad_check       = bool
    delegated_managed_identity_resource_id = string
  }))
```

Default: `{}`

### <a name="input_schedules"></a> [schedules](#input\_schedules)

Description: A map of schedules to create on AVD Scaling Plan. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time.

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

Type:

```hcl
map(object({
    name                                 = string
    days_of_week                         = set(string)
    off_peak_start_time                  = string
    off_peak_load_balancing_algorithm    = string
    ramp_down_capacity_threshold_percent = number
    ramp_down_force_logoff_users         = bool
    ramp_down_load_balancing_algorithm   = string
    ramp_down_minimum_hosts_percent      = number
    ramp_down_notification_message       = string
    ramp_down_start_time                 = string
    ramp_down_stop_hosts_when            = string
    ramp_down_wait_time_minutes          = number
    peak_start_time                      = string
    peak_load_balancing_algorithm        = string
    ramp_up_capacity_threshold_percent   = optional(number)
    ramp_up_load_balancing_algorithm     = string
    ramp_up_minimum_hosts_percent        = optional(number)
    ramp_up_start_time                   = string
  }))
```

Default:

```json
{
  "schedule1": {
    "days_of_week": [
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday"
    ],
    "name": "Weekdays",
    "off_peak_load_balancing_algorithm": "DepthFirst",
    "off_peak_start_time": "22:00",
    "peak_load_balancing_algorithm": "BreadthFirst",
    "peak_start_time": "09:00",
    "ramp_down_capacity_threshold_percent": 5,
    "ramp_down_force_logoff_users": false,
    "ramp_down_load_balancing_algorithm": "DepthFirst",
    "ramp_down_minimum_hosts_percent": 10,
    "ramp_down_notification_message": "Please log off in the next 45 minutes...",
    "ramp_down_start_time": "19:00",
    "ramp_down_stop_hosts_when": "ZeroSessions",
    "ramp_down_wait_time_minutes": 45,
    "ramp_up_capacity_threshold_percent": 10,
    "ramp_up_load_balancing_algorithm": "BreadthFirst",
    "ramp_up_minimum_hosts_percent": 20,
    "ramp_up_start_time": "05:00"
  }
}
```

### <a name="input_tags"></a> [tags](#input\_tags)

Description: Map of tags to assign to the Key Vault resource.

Type: `map(any)`

Default: `null`

### <a name="input_time_zone"></a> [time\_zone](#input\_time\_zone)

Description: The time zone of the AVD Scaling Plan.

Type: `string`

Default: `"Eastern Standard Time"`

### <a name="input_tracing_tags_enabled"></a> [tracing\_tags\_enabled](#input\_tracing\_tags\_enabled)

Description: Whether enable tracing tags that generated by BridgeCrew Yor.

Type: `bool`

Default: `false`

### <a name="input_tracing_tags_prefix"></a> [tracing\_tags\_prefix](#input\_tracing\_tags\_prefix)

Description: Default prefix for generated tracing tags

Type: `string`

Default: `"avm_"`

## Outputs

No outputs.

## Modules

No modules.

<!-- markdownlint-disable-next-line MD041 -->
## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the repository. There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
<!-- END_TF_DOCS -->
