##################################
### Firewall Policies
##################################
# Resource Group for Firewall Policy
resource "azurerm_resource_group" "fw-policy-rg" {
  name     = "fw-policy-rg"
  location = var.asia_networking_core_location

  tags = local.common_tags

}

##################################
### BASE (PARENT) POLICY
##################################
# Base (Parent) Premium Firewall Policy
resource "azurerm_firewall_policy" "parent_azfw_premium_policy" {
  name                = "${var.projectname}-parent-fwpolicy"
  resource_group_name = azurerm_resource_group.fw-policy-rg.name
  location            = var.asia_networking_core_location
  sku                 = var.firewallandpolicysku
  intrusion_detection {
    mode = "Alert" # <--- IDS only on Alert Mode (Good to have)
  }

  tags = local.common_tags

}

# Base (Parent) Premium Firewall Policy Rule Collection Group
resource "azurerm_firewall_policy_rule_collection_group" "parent_azfw_premium_policy" {
  name               = "${var.projectname}-parent-fwpolicy-rules"
  firewall_policy_id = azurerm_firewall_policy.parent_azfw_premium_policy.id
  priority           = 500
  application_rule_collection {
    name     = "app_rule_collection1"
    priority = 500
    action   = "Allow"
    rule {
      name = "allow_http_https_from_spokes"
      protocols {
        type = "Http"
        port = 80
      }
      protocols {
        type = "Https"
        port = 443
      }
      source_addresses = ["172.16.0.0/16"]
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
      source_addresses = ["172.16.0.0/16"]
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
      name                  = "AsiaFW-to-EuFW-NR1"
      protocols             = ["Any"]
      source_addresses      = ["172.16.4.0/24"]
      destination_addresses = ["172.16.8.0/24"]
      destination_ports     = ["*"]
    }
    rule {
      name                  = "EuFW-to-AsiaFW-NR1"
      protocols             = ["Any"]
      source_addresses      = ["172.16.8.0/24"]
      destination_addresses = ["172.16.4.0/24"]
      destination_ports     = ["*"]
    }
  }
}

##################################
### ASIA Region CHILD POLICY
##################################
# ASIA Region Specific Firewall Policy
resource "azurerm_firewall_policy" "asia-azfw_premium_policy" {
  name                = "${var.asia_networking_core_location}-child-fwpolicy"
  resource_group_name = azurerm_resource_group.fw-policy-rg.name
  location            = var.asia_networking_core_location
  base_policy_id      = azurerm_firewall_policy.parent_azfw_premium_policy.id
  sku                 = var.firewallandpolicysku
  intrusion_detection {
    mode = "Alert" # <--- IDS only on Alert Mode (Good to have)
  }

  tags = local.common_tags

}

# ASIA Region Specific Rule Collection Group
resource "azurerm_firewall_policy_rule_collection_group" "asia-azfw_premium_policy" {
  name               = "${var.asia_networking_core_location}-child-fwpolicy-rules"
  firewall_policy_id = azurerm_firewall_policy.asia-azfw_premium_policy.id
  priority           = 500
  ## Using base (Parent) policy of URL whitelisting
  # application_rule_collection {
  #   name     = "app_rule_collection1"
  #   priority = 500
  #   action   = "Deny"
  #   rule {
  #     name = "app_rule_collection1_rule1"
  #     protocols {
  #       type = "Http"
  #       port = 80
  #     }
  #     protocols {
  #       type = "Https"
  #       port = 443
  #     }
  #     source_addresses  = ["10.0.0.1"]
  #     destination_fqdns = ["*.microsoft.com"]
  #   }
  # }

  network_rule_collection {
    name     = "asia_network_rule_collection1"
    priority = 100
    action   = "Allow"
    rule {
      name                  = "asiaspoke_to_euspoke_allport"
      protocols             = ["Any"]
      source_addresses      = ["172.16.6.0/24", "172.16.7.0/24"]
      destination_addresses = ["172.16.9.0/24", "172.16.10.0/24"]
      destination_ports     = ["*"]
    }
    rule {
      name                  = "euspoke_to_asiaspoke_allport"
      protocols             = ["Any"]
      source_addresses      = ["172.16.9.0/24", "172.16.10.0/24"]
      destination_addresses = ["172.16.6.0/24", "172.16.7.0/24"]
      destination_ports     = ["*"]
    }

    # rule {
    #   name                  = "asia_all_ssh_mesh"
    #   protocols             = ["TCP", "UDP"]
    #   source_addresses      = ["172.16.4.0/22"]
    #   destination_addresses = ["172.16.4.0/22"]
    #   destination_ports     = ["22"]
    # }
    rule {
      name                  = "AsiaSpoke-to-AsiaNVA-NR2"
      protocols             = ["Any"]
      source_addresses      = ["172.16.6.0/24", "172.16.7.0/24"]
      destination_addresses = ["172.16.4.128/26"]
      destination_ports     = ["*"]
    }
    rule {
      name                  = "AsiaNVA-to-AsiaSpoke-NR2"
      protocols             = ["Any"]
      source_addresses      = ["172.16.4.128/26"]
      destination_addresses = ["172.16.6.0/24", "172.16.7.0/24"]
      destination_ports     = ["*"]
    }
    ### NAT GW Test RULE # <--- If Planning to Use NAT GW for Internet Egress (to avoid SNAT Port Exhaustion) 
    ## Reference Pattern for NAT GW with Azure Firewall https://azure.microsoft.com/en-us/blog/scale-azure-firewall-snat-ports-with-nat-gateway-for-large-workloads/
    rule {
      name                  = "AsiaSpoke-to-AsiaNATGW"
      protocols             = ["TCP"]
      source_addresses      = ["172.16.6.0/24"]
      destination_addresses = ["*"]
      # destination_addresses = [azurerm_public_ip.nat-asia.ip_address]
      destination_ports     = ["80", "443"]
    }
  }

  nat_rule_collection {
    name     = "nat_rule_collection1"
    priority = 300
    action   = "Dnat"
    ## DNAT Rule to SSH into VMs behind Azure Firewall
    # rule {
    #   name                = "ssh_to_asiaspoke3-vm1-lin"
    #   protocols           = ["TCP", "UDP"]
    #   source_addresses    = [var.officeip, var.myip]
    #   destination_address = azurerm_public_ip.asia_firewall_public_ip.ip_address
    #   destination_ports   = ["22"]
    #   translated_address  = "172.16.6.4"
    #   translated_port     = "22"
    # }
    rule {
      name                = "rdp_to_asiaspoke3-vm1-win"
      protocols           = ["TCP", "UDP"]
      source_addresses    = [var.officeip, var.myip]
      destination_address = azurerm_public_ip.asia_firewall_public_ip.ip_address
      destination_ports   = ["3389"]
      translated_address  = "172.16.6.5"
      translated_port     = "3389"
    }
    rule {
      name                = "ssh_to_asiaspoke4-vm1-lin"
      protocols           = ["TCP", "UDP"]
      source_addresses    = [var.officeip, var.myip]
      destination_address = azurerm_public_ip.asia_firewall_public_ip.ip_address
      destination_ports   = ["23"]
      translated_address  = "172.16.7.4"
      translated_port     = "22"
    }

  }
}

##################################
### EU Region CHILD POLICY
##################################
# EU Region Specific Policy
resource "azurerm_firewall_policy" "eu-azfw_premium_policy" {
  name                = "${var.eu_networking_core_location}-child-fwpolicy"
  resource_group_name = azurerm_resource_group.fw-policy-rg.name
  location            = var.asia_networking_core_location # Child Policy must be in same region as parent while AzFw can consume it from other region
  base_policy_id      = azurerm_firewall_policy.parent_azfw_premium_policy.id
  sku                 = var.firewallandpolicysku
  intrusion_detection {
    mode = "Alert"
  }

  tags = local.common_tags

}

# EU Region Specific Rule Collection Group
resource "azurerm_firewall_policy_rule_collection_group" "eu-azfw_premium_policy" {
  name               = "${var.eu_networking_core_location}-child-fwpolicy-rules"
  firewall_policy_id = azurerm_firewall_policy.eu-azfw_premium_policy.id
  priority           = 500
  ## Using use base (Parent) policy of URL whitelisting
  # application_rule_collection {
  #   name     = "app_rule_collection1"
  #   priority = 500
  #   action   = "Deny"
  #   rule {
  #     name = "app_rule_collection1_rule1"
  #     protocols {
  #       type = "Http"
  #       port = 80
  #     }
  #     protocols {
  #       type = "Https"
  #       port = 443
  #     }
  #     source_addresses  = ["10.0.0.1"]
  #     destination_fqdns = ["*.microsoft.com"]
  #   }
  # }

  network_rule_collection {
    name     = "eu_network_rule_collection1"
    priority = 100
    action   = "Allow"
    rule {
      name                  = "euspoke_asiaspoke_allport"
      protocols             = ["Any"]
      source_addresses      = ["172.16.9.0/24", "172.16.10.0/24"]
      destination_addresses = ["172.16.6.0/24", "172.16.7.0/24"]
      destination_ports     = ["*"]
    }
    rule {
      name                  = "asiaspoke_to_euspoke_allport"
      protocols             = ["Any"]
      source_addresses      = ["172.16.6.0/24", "172.16.7.0/24"]
      destination_addresses = ["172.16.9.0/24", "172.16.10.0/24"]
      destination_ports     = ["*"]
    }

    rule {
      name                  = "eu_all_ssh_mesh"
      protocols             = ["TCP", "UDP"]
      source_addresses      = ["172.16.8.0/22"]
      destination_addresses = ["172.16.8.0/22"]
      destination_ports     = ["22"]
    }
    rule {
      name                  = "EUSpoke-to-EUNVA-NR2"
      protocols             = ["Any"]
      source_addresses      = ["172.16.9.0/24", "172.16.10.0/24"]
      destination_addresses = ["172.16.8.128/26"]
      destination_ports     = ["*"]
    }
    rule {
      name                  = "EUNVA-to-EUSpoke-NR2"
      protocols             = ["Any"]
      source_addresses      = ["172.16.8.128/26"]
      destination_addresses = ["172.16.9.0/24", "172.16.10.0/24"]
      destination_ports     = ["*"]
    }
  }

  nat_rule_collection {
    name     = "nat_rule_collection1"
    priority = 300
    action   = "Dnat"
    rule {
      name                = "ssh_to_euspoke1-vm1"
      protocols           = ["TCP", "UDP"]
      source_addresses    = [var.myip]
      destination_address = azurerm_public_ip.eu_firewall_public_ip.ip_address
      destination_ports   = ["22"]
      translated_address  = "172.16.9.4"
      translated_port     = "22"
    }
  }
}
