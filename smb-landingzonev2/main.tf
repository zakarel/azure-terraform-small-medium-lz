
# Creating resource groups for each VNET
resource "azurerm_resource_group" "rg-spoke" {
  for_each = var.vnets

  name     = "rg-${each.value.name}-${var.product_name}"
  location = var.location
  tags = {
    source      = "terraform"
  }
}

# Creating the VNETs
resource "azurerm_virtual_network" "vnet-spoke" {
  for_each = var.vnets

  name                = "vnet-${each.value.name}-${var.product_name}"
  address_space       = [each.value.address_space]
  location            = azurerm_resource_group.rg-spoke[each.key].location
  resource_group_name = azurerm_resource_group.rg-spoke[each.key].name
  tags = {
    source      = "terraform"
  }
# Creating the subnets under hub VNET
dynamic "subnet" {
  for_each = each.key == keys(var.vnets)[0] ? local.subnets_hub : {}
  content {
    name                 = subnet.key
    address_prefix       = subnet.value.address_prefix
  }
}
# Creating the subnets under prod VNET
dynamic "subnet" {
  for_each = each.key == keys(var.vnets)[1] ? local.subnets_prod : {}
  content {
    name                 = subnet.key
    address_prefix       = subnet.value.address_prefix
  }
}
# Creating the subnets under staging VNET
dynamic "subnet" {
  for_each = each.key == keys(var.vnets)[2] ? local.subnets_staging : {}
  content {
    name                 = subnet.key
    address_prefix       = subnet.value.address_prefix
  }
}
# Creating the subnets under dev VNET
dynamic "subnet" {
  for_each = each.key == keys(var.vnets)[3] ? local.subnets_dev : {}
  content {
    name                 = subnet.key
    address_prefix       = subnet.value.address_prefix
  }
}
}
# Creating the Network Security Groups
resource "azurerm_network_security_group" "nsg" {
  for_each = var.vnets

  name                = "nsg-${each.value.name}-${var.product_name}"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg-spoke[each.key].name

  security_rule {
    name                       = "ssh"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "rdp"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "http"
    priority                   = 120
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "https"
    priority                   = 130
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "allow_all_in_vnet_traffic"
    priority                   = 140
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "VirtualNetwork"
  }
  security_rule {
    name                       = "allow_all_out_vnet_traffic"
    priority                   = 150
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "VirtualNetwork"
  }

}