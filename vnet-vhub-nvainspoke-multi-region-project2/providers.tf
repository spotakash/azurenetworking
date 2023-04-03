terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.47.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">=3.1.0"
    }
  }
  backend "azurerm" {
  }
}



provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

locals {
  common_tags = {
    environment = "test"
    project     = "vhub-nvainspoke-multi-region"
  }
}

# locals {
#   prefix_cidr = var.vnet_address_space
# }