terraform {
  # Live modules pin exact Terraform version; generic modules let consumers pin the version.
  # The latest version of Terragrunt (v0.29.0 and above) recommends Terraform 0.15.0 or above.
  required_version = "= 0.15.0"

  # Live modules pin exact provider version; generic modules let consumers pin the version.
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 2.25.0"
    }
  }
}

resource "azurerm_resource_group" "resource_group" {
  name     = var.name
  location = var.location
}