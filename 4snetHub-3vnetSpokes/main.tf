terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.65"
    }
  }
}
variable "spokes" {
  description = "Map of spokes to create"
  type = map(object({
    name          = string
    address_space = string
  }))
  default = {
    spoke1 = { name = "spoke1", address_space = "10.10.0.0/16" },
    spoke2 = { name = "spoke2", address_space = "10.100.0.0/16" },
    spoke3 = { name = "spoke3", address_space = "10.200.0.0/16" }
  }
}

resource "azurerm_resource_group" "rg-hub" {
  name     = "rg-hub-${var.env}-${var.hub-project-name}"
  location = var.location
  tags = {
    environment = var.env
    source      = "terraform"
  }
}

# Defining The Hub VNET
resource "azurerm_virtual_network" "vnet-hub" {
  name                = "vnet-hub-${var.env}-${var.hub-project-name}"
  address_space       = ["192.168.0.0/20"]
  location            = azurerm_resource_group.rg-hub.location
  resource_group_name = azurerm_resource_group.rg-hub.name
  tags = {
    environment = var.env
    source      = "terraform"
  }
}
# DMZ Snet1
resource "azurerm_subnet" "snet1-hub" {
  name                 = "snet-DMZ-${var.env}-${var.hub-project-name}"
  resource_group_name  = azurerm_resource_group.rg-hub.name
  virtual_network_name = azurerm_virtual_network.vnet-hub.name
  address_prefixes     = ["192.168.0.0/25"]
}
# Management Snet2
resource "azurerm_subnet" "snet2-hub" {
  name                 = "snet-management-${var.env}-${var.hub-project-name}"
  resource_group_name  = azurerm_resource_group.rg-hub.name
  virtual_network_name = azurerm_virtual_network.vnet-hub.name
  address_prefixes     = ["192.168.0.0/24"]
}
# Shared Snet3
resource "azurerm_subnet" "snet3-hub" {
  name                 = "snet-shared-${var.env}-${var.hub-project-name}"
  resource_group_name  = azurerm_resource_group.rg-hub.name
  virtual_network_name = azurerm_virtual_network.vnet-hub.name
  address_prefixes     = ["192.168.0.0/22"]
}
# Gateway Snet4
resource "azurerm_subnet" "snet4-hub" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.rg-hub.name
  virtual_network_name = azurerm_virtual_network.vnet-hub.name
  address_prefixes     = ["192.168.0.0/27"]
}
# Hub NIC
resource "azurerm_network_interface" "nic-hub" {
  name                 = "nic-hub-${var.env}-${var.hub-project-name}"
  location             = azurerm_resource_group.rg-hub.location
  resource_group_name  = azurerm_resource_group.rg-hub.name
  enable_ip_forwarding = true

  ip_configuration {
    name                          = "ip-hub-${var.env}-${var.hub-project-name}"
    subnet_id                     = azurerm_subnet.snet2-hub.id
    private_ip_address_allocation = "Dynamic"
  }
  tags = {
    environment = var.env
    source      = "terraform"
  }
}

# Spokes
resource "azurerm_resource_group" "rg-spoke" {
  for_each = var.spokes

  name     = "rg-spoke-${var.env}-${each.value.name}"
  location = var.location
  tags = {
    environment = var.env
    source      = "terraform"
  }
}

resource "azurerm_virtual_network" "vnet-spoke" {
  for_each = var.spokes

  name                = "vnet-spoke-${var.env}-${each.value.name}"
  address_space       = [each.value.address_space]
  location            = azurerm_resource_group.rg-spoke[each.key].location
  resource_group_name = azurerm_resource_group.rg-spoke[each.key].name
  tags = {
    environment = var.env
    source      = "terraform"
  }
}

resource "azurerm_subnet" "snet-spoke" {
  for_each = var.spokes

  name                 = "snet-workload-${each.key}"
  resource_group_name  = azurerm_resource_group.rg-spoke[each.key].name
  virtual_network_name = azurerm_virtual_network.vnet-spoke[each.key].name
  address_prefixes     = [cidrsubnet(each.value.address_space, 8, 0)]
}