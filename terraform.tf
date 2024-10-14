terraform {
    backend "azurerm" {
        storage_account_name = "labelstudiotfstates"
        container_name       = "tfstates"
        key                  = "terraform.tfstate"
        resource_group_name  = "Terraform-UpSkilling"
    }
    required_providers {
        azurerm = {
        source = "hashicorp/azurerm"
        version = "4.4.0"
        }
    }
    }

