variable "enable_telemetry" {
  type        = bool
  default     = true
  description = <<DESCRIPTION
This variable controls whether or not telemetry is enabled for the module.
For more information see https://aka.ms/avm/telemetryinfo.
If it is set to false, then no telemetry will be collected.
DESCRIPTION
}

variable "scalingplan" {
  type        = string
  default     = "avdscalingplan"
  description = "The name of the AVD Scaling Plan."
}

variable "host_pool" {
  type        = string
  default     = "avdhostpool"
  description = "The name of the AVD Host Pool to assign the scaling plan to."
}

variable "resource_group_name" {
  type        = string
  default     = "rg-avm-test"
  description = "The resource group where the AVD Host Pool is deployed."
}
