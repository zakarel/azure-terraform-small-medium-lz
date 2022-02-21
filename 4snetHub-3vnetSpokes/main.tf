terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.65"
    }
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

# Spoke 1
resource "azurerm_resource_group" "rg-spoke1" {
  name     = "rg-spoke-${var.env}-${var.spoke1-name}"
  location = var.location
  tags = {
    environment = var.env
    source      = "terraform"
  }
}

resource "azurerm_virtual_network" "vnet-spoke1" {
  name                = "vnet-spoke-${var.env}-${var.spoke1-name}"
  address_space       = ["10.10.0.0/16"]
  location            = azurerm_resource_group.rg-spoke1.location
  resource_group_name = azurerm_resource_group.rg-spoke1.name
  tags = {
    environment = var.env
    source      = "terraform"
  }
}
resource "azurerm_subnet" "snet-spoke1" {
  name                 = "snet-workload1"
  resource_group_name  = azurerm_resource_group.rg-spoke1.name
  virtual_network_name = azurerm_virtual_network.vnet-spoke1.name
  address_prefixes     = ["10.10.0.0/16"]
}


# Spoke 2
resource "azurerm_resource_group" "rg-spoke2" {
  name     = "rg-spoke-${var.env}-${var.spoke2-name}"
  location = var.location
  tags = {
    environment = var.env
    source      = "terraform"
  }
}
resource "azurerm_virtual_network" "vnet-spoke2" {
  name                = "vnet-spoke-${var.env}-${var.spoke2-name}"
  address_space       = ["10.100.0.0/16"]
  location            = azurerm_resource_group.rg-spoke2.location
  resource_group_name = azurerm_resource_group.rg-spoke2.name
  tags = {
    environment = var.env
    source      = "terraform"
  }
}
resource "azurerm_subnet" "snet-spoke2" {
  name                 = "snet-workload2"
  resource_group_name  = azurerm_resource_group.rg-spoke2.name
  virtual_network_name = azurerm_virtual_network.vnet-spoke2.name
  address_prefixes     = ["10.100.0.0/16"]
}


# Spoke 3
resource "azurerm_resource_group" "rg-spoke3" {
  name     = "rg-spoke-${var.env}-${var.spoke3-name}"
  location = var.location
  tags = {
    environment = var.env
    source      = "terraform"
  }
}
resource "azurerm_virtual_network" "vnet-spoke3" {
  name                = "vnet-spoke-${var.env}-${var.spoke3-name}"
  address_space       = ["10.200.0.0/16"]
  location            = azurerm_resource_group.rg-spoke3.location
  resource_group_name = azurerm_resource_group.rg-spoke3.name
  tags = {
    environment = var.env
    source      = "terraform"
  }
}
resource "azurerm_subnet" "snet-spoke3" {
  name                 = "snet-workload3"
  resource_group_name  = azurerm_resource_group.rg-spoke3.name
  virtual_network_name = azurerm_virtual_network.vnet-spoke3.name
  address_prefixes     = ["10.200.0.0/16"]
}