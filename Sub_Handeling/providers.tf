terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">= 3.23.0"
    }
    time = {
      source = "hashicorp/time"
      version = ">= 0.9.1"
    }
  }
}

provider "azurerm" {
features {}
    client_id     = var.client_id
    client_secret = var.client_secret
    tenant_id     = var.tenant_id
    subscription_id = "*******"
    
}



provider "time" {
  # Configuration options
}