output "resource" {
  description = "This output is the full output for the resource to allow flexibility to reference all possible values for the resource. Example usage: module.<modulename>.resource.id"
  value       = var.virtual_desktop_scaling_plan_type == "Pooled" ? azurerm_virtual_desktop_scaling_plan.this[0] : azapi_resource.this[0]
}

output "resource_id" {
  description = "This output is the full output for the resource to allow flexibility to reference all possible values for the resource. Example usage: module.<modulename>.resource.id"
  value       = var.virtual_desktop_scaling_plan_type == "Pooled" ? azurerm_virtual_desktop_scaling_plan.this[0].id : azapi_resource.this[0].id
}
