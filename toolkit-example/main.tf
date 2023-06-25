# create the start of the terraform file
terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "2.46.0"
    }
  }
}
resource "azurerm_app_service_plan" "example" {
  name                = "example-app-service-plan"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  kind                = "Linux"
  reserved            = true

  sku {
    tier = "PremiumV2"
    size = "P1v2"
  }
}