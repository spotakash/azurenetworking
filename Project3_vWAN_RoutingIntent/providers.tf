terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.55.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">=3.1.0"
    }
    azapi = {
      source  = "azure/azapi"
      version = ">=1.5.0"
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
    environment = "securehub-multi-region"
    project     = "routing-intent"
  }
}

