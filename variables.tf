variable "location" {
  description = "The region to deploy resources to in Azure"
  type        = string
  default     = "westeurope"
}

variable "resource_group" {
  description = "Resource group to use"
  type        = string
  default     = "Terraform-UpSkilling"
}

variable "service_plan_name" {
  description = "Name of the service plan"
  type        = string
  default     = "Terraform-UpSkilling-serv-plan"
}

variable "web_app_name" {
  description = "Name of the web app"
  type        = string
  default     = "Terraform-UpSkilling-web-app"
}

variable "tenant_id" {
  description = "Tenant id of the Azure subscription. This can typically be found when switching directories"
  type        = string
  default     = ""
}


variable "storage_account_name" {
  description = "Name of the storage account"
  type        = string
  default     = "tfupskillingstrgaccount"
}