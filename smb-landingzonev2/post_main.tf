/* THIS FILE IS A WORK IN PROGRESS
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.84"
    }
  }
}

  



data "terraform_remote_state" "main" {
    backend = "local"
    config = {
        path = "../terraform.tfstate"
    }
}

resource "azurerm_subnet_network_security_group_association" "association" {
    for_each = data.terraform_remote_state.main.outputs.subnet_ids

    subnet_id                 = each.value
    network_security_group_id = data.terraform_remote_state.main.outputs.nsg_ids[each.key]
}

resource "azurerm_virtual_network_peering" "peering" {
    count                     = length(data.terraform_remote_state.main.outputs.vnet_spoke_ids)
    name                      = "peering${count.index}"
    resource_group_name       = data.terraform_remote_state.main.outputs.resource_group_ids[var.vnets[count.index].name]
    virtual_network_name      = data.terraform_remote_state.main.outputs.vnet_spoke_ids[var.vnets[count.index].name]
    remote_virtual_network_id = data.terraform_remote_state.main.outputs.vnet_hub_id
    allow_forwarded_traffic   = true
}
 */