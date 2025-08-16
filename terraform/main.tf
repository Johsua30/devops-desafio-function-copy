provider "azurerm" {
  features {}
  subscription_id = "4dc63939-80f6-4f50-bd19-bc605cf2786d"
}

# Creamos un número aleatorio para el nombre de la app
resource "random_integer" "rand" {
  min = 10000
  max = 99999
}

# Creamos las storage account donde se van a alojar los storage container
resource "azurerm_storage_account" "origin" {
  name                     = "storageorigin${random_integer.rand.result}"
  resource_group_name      = local.rg_name
  location                 = local.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_account" "dest" {
  name                     = "storagedest${random_integer.rand.result}"
  resource_group_name      = local.rg_name
  location                 = local.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# Creamos los storage container que van a contener los archivos
resource "azurerm_storage_container" "origin" {
  name                  = "origen"
  storage_account_name  = azurerm_storage_account.origin.name
  container_access_type = "private"
}

resource "azurerm_storage_container" "dest" {
  name                  = "destino"
  storage_account_name  = azurerm_storage_account.dest.name
  container_access_type = "private"
}

# Creamos el service plan para la app de copiado
resource "azurerm_service_plan" "plan" {
  name = "function-copy-plan"
  resource_group_name = local.rg_name
  location = local.location
  os_type  = "Linux"
  sku_name = "Y1"
}

# Creamos el ambiente para correr la función
resource "azurerm_linux_function_app" "func" {
  name                       = "func-copy-${random_integer.rand.result}"
  location                   = local.location
  resource_group_name        = local.rg_name
  service_plan_id            = azurerm_service_plan.plan.id
  storage_account_name       = azurerm_storage_account.origin.name
  storage_account_access_key = azurerm_storage_account.origin.primary_access_key

  identity {
    type = "SystemAssigned"
  }

  site_config {
    application_stack {
      python_version = "3.11"
    }
  }

  app_settings = {
    AzureWebJobsStorage      = azurerm_storage_account.origin.primary_connection_string
    ORIGIN_CONTAINER         = azurerm_storage_container.origin.name
    DESTINATION_CONTAINER    = azurerm_storage_container.dest.name
    DESTINATION_CONNECTION   = azurerm_storage_account.dest.primary_connection_string
    FUNCTIONS_WORKER_RUNTIME = "python"
  }
}
