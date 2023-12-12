variable "location" {
  type    = string
  description = "azure resources location"
  default = "eastus"
}
variable "product-name" {
  type = string
  nullable = false
  description = "(Mandatory) Project/Application name. e.g skynet \nThis will be used as prefix for all resources created."
  
}
variable "vnets" {
  description = "Map of vnets to create"
  type = map(object({
    name          = string
    address_space = string
  }))
  default = {
    spoke1 = { name = "hub", address_space = "10.0.0.0/20" },
    spoke2 = { name = "prod", address_space = "10.1.0.0/16" },
    spoke3 = { name = "staging", address_space = "10.2.0.0/16" },
    spoke4 = { name = "dev", address_space = "10.3.0.0/16" }
  }
}
locals {
  subnets = {
    "snet-management" = {
      address_prefix = "10.0.1.0/24"
    },
    "GatewaySubnet" = {
      address_prefix = "10.0.15.224/27"
    },
    "snet-shared" = {
      address_prefix = "10.0.4.0/22"
    },
    "AzureFirewallSubnet" = {
      address_prefix = "10.0.15.0/26"
    }
  }
}