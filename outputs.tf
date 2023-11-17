output "scaling_plan_name" {
  description = "The name of the scaling plan"
  value       = azurerm_virtual_desktop_scaling_plan.scplan.name
}

output "scaling_plan_id" {
  description = "The ID of the scaling plan"
  value       = azurerm_virtual_desktop_scaling_plan.scplan.id
}
