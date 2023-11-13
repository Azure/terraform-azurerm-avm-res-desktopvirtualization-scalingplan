output "scaling_plan_name" {
  description = "The name of the scaling plan"
  value       = azurerm_desktop_virtualization_scaling_plan.scaling_plan.name
}

output "scaling_plan_id" {
  description = "The ID of the scaling plan"
  value       = azurerm_desktop_virtualization_scaling_plan.scaling_plan.id
}
