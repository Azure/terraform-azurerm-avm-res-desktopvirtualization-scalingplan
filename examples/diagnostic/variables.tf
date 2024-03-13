variable "enable_telemetry" {
  type        = bool
  default     = true
  description = <<DESCRIPTION
This variable controls whether or not telemetry is enabled for the module.
For more information see https://aka.ms/avm/telemetryinfo.
If it is set to false, then no telemetry will be collected.
DESCRIPTION
}

variable "name" {
  type        = string
  default     = "avdsdiagcalingplan"
  description = "The name of the AVD Scaling Plan."
}

variable "description" {
  type        = string
  default     = "AVD Scaling Plan"
  description = "The description of the AVD Scaling Plan."
}

variable "time_zone" {
  type        = string
  description = "The time zone of the AVD Scaling Plan."
  default     = "Eastern Standard Time"
}


variable "host_pool" {
  type        = string
  default     = "avdhostpool1"
  description = "The name of the AVD Host Pool to assign the scaling plan to."
}

