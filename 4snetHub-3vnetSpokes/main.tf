terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.83"
    }
  }
}

# Creating resource groups for each VNET
resource "azurerm_resource_group" "rg-spoke" {
  for_each = var.vnets

  name     = "rg-${each.value.name}"
  location = var.location
  tags = {
    source      = "terraform"
  }
}

# Creating the VNETs
resource "azurerm_virtual_network" "vnet-spoke" {
  for_each = var.vnets

  name                = "vnet-${each.value.name}"
  address_space       = [each.value.address_space]
  location            = azurerm_resource_group.rg-spoke[each.key].location
  resource_group_name = azurerm_resource_group.rg-spoke[each.key].name
  tags = {
    source      = "terraform"
  }

dynamic "subnet" {
  for_each = each.key == keys(var.vnets)[0] ? local.subnets : {}
  content {
    name                 = subnet.key
    address_prefix       = subnet.value.address_prefix
  }
}
}
/*
# Hub NIC
resource "azurerm_network_interface" "nic-hub" {
  name                 = "nic-hub-${var.env}-${var.product-name}"
  location             = azurerm_resource_group.rg-hub.location
  resource_group_name  = azurerm_resource_group.rg-hub.name
  enable_ip_forwarding = true

  ip_configuration {
    name                          = "ip-hub-${var.env}-${var.product-name}"
    subnet_id                     = azurerm_subnet.snet2-hub.id
    private_ip_address_allocation = "Dynamic"
  }
  tags = {
    
    source      = "terraform"
  }
} */

# Spokes
/* resource "azurerm_resource_group" "rg-spoke" {
  for_each = var.vnets

  name     = "rg-spoke-${var.env}-${each.value.name}"
  location = var.location
  tags = {
    
    source      = "terraform"
  }
} */

