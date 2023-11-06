# We pick a random region from this list.
locals {
  role_definition_resource_substring = "/providers/Microsoft.Authorization/roleDefinitions"
  azure_regions = [
    "Australia East",
    "Canada Central",
    "Canada East",
    "Central India",
    "Central US",
    "East US",
    "East US 2",
    "Japan East",
    "North Central US",
    "North Europe",
    "South Central US",
    "UK South",
    "UK West",
    "West Central US",
    "West Europe",
    "West US",
    "West US 2",
    "West US 3"
  ]
}
