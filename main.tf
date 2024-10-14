
locals {
  tags = {
    project = "tfupskilling"
  }
}


### Bucket


resource "azurerm_storage_account" "qmtfupskilling" {
  access_tier                     = "Hot"
  account_kind                    = "StorageV2"
  account_replication_type        = "LRS"
  account_tier                    = "Standard"
  allow_nested_items_to_be_public = true
  cross_tenant_replication_enabled = true
  default_to_oauth_authentication  = false
  infrastructure_encryption_enabled = false
  is_hns_enabled                    = false
  location                      = var.location
  min_tls_version               = "TLS1_2"
  name                          = var.storage_account_name
  nfsv3_enabled                 = false
  public_network_access_enabled = true
  queue_encryption_key_type     = "Service"
  resource_group_name           = var.resource_group
  sftp_enabled                  = false
  shared_access_key_enabled     = true
  table_encryption_key_type     = "Service"
  tags                          = local.tags
  blob_properties {
    change_feed_enabled = false
    last_access_time_enabled = false
    versioning_enabled       = false
    container_delete_retention_policy {
      days = 7
    }
    delete_retention_policy {
      days = 7
    }
    cors_rule {
      allowed_headers    = ["*"]
      allowed_methods    = ["GET", "HEAD", "POST", "PUT", "DELETE"]
      allowed_origins    = ["*"]
      exposed_headers    = ["*"]
      max_age_in_seconds = 3600
    }
  }
  network_rules {
    bypass                     = ["AzureServices"]
    default_action             = "Allow"
    ip_rules                   = []
    virtual_network_subnet_ids = []
  }
  queue_properties {
    hour_metrics {
      enabled               = true
      include_apis          = true
      retention_policy_days = 7
      version               = "1.0"
    }
  }
  share_properties {
    retention_policy {
      days = 7
    }
  }
}

resource "azurerm_storage_container" "qmtfupskilling" {
  name                  = "data"
  storage_account_name  = azurerm_storage_account.qmtfupskilling.name
  container_access_type = "private"
}



### Web app
resource "azurerm_service_plan" "tfupskilling-service-plan" {
  location            = var.location
  name                = var.service_plan_name
  os_type             = "Linux"
  resource_group_name = var.resource_group
  sku_name            = "B1"
  tags                = local.tags
}



resource "azurerm_linux_web_app" "qmtfupskilling" {
  app_settings = {
    STORAGE_TYPE                 = "azure"
    STORAGE_AZURE_ACCOUNT_NAME   = azurerm_storage_account.qmtfupskilling.name
    STORAGE_AZURE_ACCOUNT_KEY    = azurerm_storage_account.qmtfupskilling.primary_access_key
    STORAGE_AZURE_CONTAINER_NAME = azurerm_storage_container.qmtfupskilling.name
    STORAGE_AZURE_FOLDER         = ""
  }
  client_affinity_enabled   = false
  https_only                = true
  location                  = var.location
  name                      = var.web_app_name
  resource_group_name       = var.resource_group
  service_plan_id           = azurerm_service_plan.tfupskilling-service-plan.id
  tags                      = local.tags
  virtual_network_subnet_id = null
  identity {
    type = "SystemAssigned"
  }
  site_config {
    always_on                         = true
    app_command_line                  = ""
    ftps_state                        = "FtpsOnly"
    health_check_eviction_time_in_min = 10
    health_check_path                 = "/"
    use_32_bit_worker                 = false
    worker_count                      = 1
    application_stack {
      docker_image_name        = "heartexlabs/label-studio:1.9.1.post0"
      docker_registry_password = null
      docker_registry_url      = "https://docker.io"
      docker_registry_username = null
    }
  }
  logs {
    application_logs {
      file_system_level = "Error"
    }
  }
}
