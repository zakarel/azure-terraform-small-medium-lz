variable "location" {
  type    = string
  description = "azure resources location"
  default = "eastus"
}
variable "hub-project-name" {
  type = string
  description = "(mandatory) the project/app name. e.g Cars Manufacturing"
}
variable "env" {
  type = string
  description = "(mandatory) the environment for all the resources in this setup. e.g dev/prod/qa"
}
variable "spoke1-name" {
  type = string
  description = "(mandatory) the name of the app in spoke1. e.g app1/function2"  
}
variable "spoke2-name" {
  type = string
  description = "(mandatory) the name of the app in spoke2. e.g app1/function2"
  
}
variable "spoke3-name" {
  type = string
  description = "(mandatory) the name of the app in spoke3. e.g app1/function2"
  
}
# Used for auto signin
/*
variable "subscription_id" {
  type = string
  description = "your subscription ID"
}

variable "client_id" {
  type = string
  description = "your client ID"
}
*/