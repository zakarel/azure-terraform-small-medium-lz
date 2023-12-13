output "subnet_ids" {
  value = { for v in azurerm_virtual_network.vnet-spoke : v.name => [for s in v.subnet : s.id] }
  description = "The IDs of the subnets"
}

output "nsg_ids" {
  value = { for n in azurerm_network_security_group.nsg : n.name => n.id }
  description = "The IDs of the NSGs"
}

output "vnet_spoke_ids" {
  value = { for v in azurerm_virtual_network.vnet-spoke : v.name => v.id }
  description = "The IDs of the spoke VNets"
}

output "resource_group_ids" {
  value = { for r in azurerm_resource_group.rg-spoke : r.name => r.id }
  description = "The IDs of the resource groups"
}

output "product-name" {
  value = var.product_name
  description = "The product name"
  
}