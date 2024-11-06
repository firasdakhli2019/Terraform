provider "azurerm" {
  features {}
  
  # ## used only with App_registry (in CI CD for exemple)
  client_id = ""
  client_secret = ""
  tenant_id = ""
  subscription_id = ""
}