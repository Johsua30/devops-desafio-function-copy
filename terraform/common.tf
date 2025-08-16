data "azurerm_resource_group" "rg" {
  name = "rg-jelseser"
}

# Definimos como variables locales el nombre del resource group y la región
locals {
  rg_name  = "rg-jelseser"
  location = "East US 2"
}