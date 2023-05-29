# Firewall Policies
resource "azurerm_resource_group" "firewall_policy" {
  name     = "${var.projectname}-firewall-policy"
  location = var.core_location

  tags = local.common_tags
}

# Parent Policy
resource "azurerm_firewall_policy" "parent_firewall_policy" {
  name                = "${var.projectname}-parent-firewall-policy"
  resource_group_name = azurerm_resource_group.firewall_policy.name
  location            = azurerm_resource_group.firewall_policy.location
  sku                 = var.firewall_sku
  intrusion_detection {
    mode = "Alert"
  }

  tags = local.common_tags
}

resource "azurerm_firewall_policy_rule_collection_group" "parent_firewall_policy_rule" {
  for_each           = var.spoke_vnets_ip_groups
  name               = "${var.projectname}-parent-fwpolicy-rules"
  firewall_policy_id = azurerm_firewall_policy.parent_firewall_policy.id
  priority           = 500
  application_rule_collection {
    name     = "app_rule_collection1"
    priority = 500
    action   = "Allow"
    rule {
      name = "allowed_url_from_spokes"
      protocols {
        type = "Http"
        port = 80
      }
      protocols {
        type = "Https"
        port = 443
      }
      source_ip_groups = [
        azurerm_ip_group.spoke_vnets["NCU-HUB"].id,
        azurerm_ip_group.spoke_vnets["WCU-HUB"].id
      ]
      destination_fqdns = [
        "*.microsoft.com",
        "*.azure.com",
        "*.ubuntu.com",
        "*.storage.azure.net",
        "*.ifconfig.me"
      ]
    }
    rule {
      name = "allow_53_from_spokes"
      protocols {
        type = "Http"
        port = 53
      }
      source_ip_groups = [
        azurerm_ip_group.spoke_vnets["NCU-HUB"].id,
        azurerm_ip_group.spoke_vnets["WCU-HUB"].id
      ]
      destination_fqdns = [
        "*.microsoft.com",
        "*.azure.com",
        "*.ubuntu.com",
        "*.storage.azure.net"
      ]
    }

  }

  network_rule_collection {
    name     = "network_rule_collection1"
    priority = 400
    action   = "Allow"
    rule {
      name      = "HUB-to-HUB"
      protocols = ["Any"]
      source_ip_groups = [
        azurerm_ip_group.vhub["NCU-HUB"].id,
        azurerm_ip_group.vhub["WCU-HUB"].id
      ]
      destination_ip_groups = [
        azurerm_ip_group.vhub["NCU-HUB"].id,
        azurerm_ip_group.vhub["WCU-HUB"].id
      ]
      destination_ports = ["*"]
    }
  }
}

# Child Policy
resource "azurerm_firewall_policy" "child_firewall_policy" {
  for_each            = var.spoke_vnets_ip_groups
  name                = "${each.value["name"]}-child-firewall-policy"
  resource_group_name = azurerm_resource_group.firewall_policy.name
  location            = azurerm_resource_group.firewall_policy.location
  base_policy_id      = azurerm_firewall_policy.parent_firewall_policy.id
  sku                 = var.firewall_sku
  intrusion_detection {
    mode = "Alert"
  }

  tags = local.common_tags
}

resource "azurerm_firewall_policy_rule_collection_group" "child_firewall_policy_rule" {
  for_each           = var.spoke_vnets_ip_groups
  name               = "${each.value["name"]}-child_firewall_policy_rule"
  firewall_policy_id = azurerm_firewall_policy.child_firewall_policy[each.key].id
  priority           = 500
  network_rule_collection {
    name     = "${each.value["location"]}-child_network_rule_collection"
    priority = 100
    action   = "Allow"
    # SPOKE TO SECURED HUB
    rule {
      name                  = "${each.value["location"]}-SPOKE-to-HUB-FIREWALL"
      protocols             = ["Any"]
      source_ip_groups      = [azurerm_ip_group.spoke_vnets[each.key].id]
      destination_ip_groups = [azurerm_ip_group.vhub[each.key].id]
      destination_ports     = ["*"]
    }
    # SECURED HUB TO SPOKE
    rule {
      name                  = "HUB-FIREWALL-to-${each.value["location"]}-SPOKE"
      protocols             = ["Any"]
      source_ip_groups      = [azurerm_ip_group.vhub[each.key].id]
      destination_ip_groups = [azurerm_ip_group.spoke_vnets[each.key].id]
      destination_ports     = ["*"]
    }
    # SPOKE TO OTHER HUB SPOKES
    rule {
      name      = "CrossHUB-Spoke-Communication"
      protocols = ["Any"]
      source_ip_groups = [
        azurerm_ip_group.spoke_vnets[each.key].id
      ]
      destination_ip_groups = [
        for key, value in azurerm_ip_group.spoke_vnets : value.id if key != each.key
      ]
      destination_ports = ["*"]
    }
  }
  nat_rule_collection {
    name     = "${each.value["location"]}-child_nat_rule_collection"
    priority = 300
    action   = "Dnat"
    rule {
      name                = "DNAT-to-${each.value["name"]}-vm"
      protocols           = ["TCP"]
      source_ip_groups    = [azurerm_ip_group.myips.id]
      destination_address = azurerm_firewall.securehub[each.key].virtual_hub[0].public_ip_addresses[0]
      destination_ports   = ["22"]
      translated_port     = "22"
      translated_address  = azurerm_network_interface.vm[each.key].private_ip_address
    }
  }

}