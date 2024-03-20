terraform {
  backend "azurerm" {
    resource_group_name  = "cloud-shell-storage-eastus"
    storage_account_name = "tfbackend2024"
    container_name       = "tfbackend"
    key                  = "prod.terraform.tfstate"
  }
}
