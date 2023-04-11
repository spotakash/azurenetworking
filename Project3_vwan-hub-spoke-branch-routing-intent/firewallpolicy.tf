# Resource Group for Firewall Policy
resource "azurerm_resource_group" "common_azfw_premium_policy" {
  name     = "common_azfw_premium_policy-rg"
  location = var.primary_location_asia
}

# Common Premium Firewall Policy
resource "azurerm_firewall_policy" "common_azfw_premium_policy" {
  name                = "common_azfw_premium_policy"
  resource_group_name = azurerm_resource_group.common_azfw_premium_policy.name
  location            = var.primary_location_asia
}

# Common Premium Firewall Policy Rule Collection Group
resource "azurerm_firewall_policy_rule_collection_group" "common_azfw_premium_policy" {
  name               = "common-fwpolicy-premiun-rcg"
  firewall_policy_id = azurerm_firewall_policy.common_azfw_premium_policy.id
  priority           = 500
  application_rule_collection {
    name     = "app_rule_collection1"
    priority = 500
    action   = "Deny"
    rule {
      name = "app_rule_collection1_rule1"
      protocols {
        type = "Http"
        port = 80
      }
      protocols {
        type = "Https"
        port = 443
      }
      source_addresses  = ["10.0.0.1"]
      destination_fqdns = ["*.microsoft.com"]
    }
  }

  network_rule_collection {
    name     = "network_rule_collection1"
    priority = 400
    action   = "Deny"
    rule {
      name                  = "network_rule_collection1_rule1"
      protocols             = ["TCP", "UDP"]
      source_addresses      = ["10.0.0.1"]
      destination_addresses = ["192.168.1.1", "192.168.1.2"]
      destination_ports     = ["80", "1000-2000"]
    }
  }

  nat_rule_collection {
    name     = "nat_rule_collection1"
    priority = 300
    action   = "Dnat"
    rule {
      name                = "nat_rule_collection1_rule1"
      protocols           = ["TCP", "UDP"]
      source_addresses    = ["*"]
      destination_address = "${output.asia_firewall_public_ip}"
      destination_ports   = ["22"]
      translated_address  = "172.16.7.4"
      translated_port     = "22"
    }
  }
}