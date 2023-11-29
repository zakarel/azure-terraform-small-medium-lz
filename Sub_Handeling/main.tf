locals { 
  billing_account_name    = "***"
  enrollment_account_name = "***"
}

variable "management_group_id" {
  type = string
}


data "azurerm_billing_enrollment_account_scope" "billing2" {
  billing_account_name    = local.billing_account_name
  enrollment_account_name = local.enrollment_account_name
}


resource "azurerm_subscription" "new_sub5" {
  subscription_name = var.subscription_name
  billing_scope_id  = data.azurerm_billing_enrollment_account_scope.billing2.id
  workload = var.workload
    tags = {
    Ticket_Number = var.ticket_number
    Owner_Name = var.owner_name
    Technical_Focal_Point = var.technical_focal_point
    Creation_Date = var.creation_date
  }
}


  data "azurerm_management_group" "mgmtgroup1" {
  name = var.management_group_id
}


resource "azurerm_management_group_subscription_association" "mgmt_to_sub5" {
 management_group_id = data.azurerm_management_group.mgmtgroup1.id              
 subscription_id = "/subscriptions/${azurerm_subscription.new_sub5.subscription_id}"
 #provisioner "local-exec" {
 #command = "az managementpartner create --partner-id ***"
#}
}


data "azurerm_subscription" "sub_id" {
  subscription_id = "${azurerm_subscription.new_sub5.subscription_id}"
  #display_name = "${azurerm_subscription.new_sub5.display_name}"
}



# output "sub_id" {
#   value = "${azurerm_subscription.new_sub5.subscription_id}"
# }

# resource "null_resource" "sub_id_export" {

#   provisioner "local-exec" {
#     command = "echo ${azurerm_subscription.new_sub5.subscription_id} > /home/runner/sub_id.txt"
#   }
# }

