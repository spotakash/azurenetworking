#############
### CORE WAN
#############

# Virtual WAN and vHUB Resources
resource "azurerm_resource_group" "vwan" {
  name     = "${var.projectname}-rg"
  location = var.asia_networking_core_location

  tags = local.common_tags
}

# Core vWAN
resource "azurerm_virtual_wan" "wan" {
  name                           = "${var.projectname}-wan"
  resource_group_name            = azurerm_resource_group.vwan.name
  location                       = var.asia_networking_core_location
  allow_branch_to_branch_traffic = true
  type                           = "Standard"

  tags = local.common_tags

}

################################
### CORE ASIA Network Components
################################
# Asia vHUB
resource "azurerm_virtual_hub" "vhub-asia" {
  name                = "${var.asia_networking_core_location}-hub"
  location            = var.asia_networking_core_location
  resource_group_name = azurerm_resource_group.vwan.name
  address_prefix      = "${var.address_space}.0.0/23"
  virtual_wan_id      = azurerm_virtual_wan.wan.id
  sku                 = "Standard"

  tags = local.common_tags

}

# # Asia vHUB VPN Gateway (if want to establish VPN connection to on-premises)
# resource "azurerm_vpn_gateway" "vpn-hub-asia-gw" {
#   name                = "${var.asia_networking_core_location}-vpn-gw"
#   location            = var.asia_networking_core_location
#   resource_group_name = azurerm_resource_group.vwan.name
#   virtual_hub_id      = azurerm_virtual_hub.vhub-asia.id
#   scale_unit          = 1
#   depends_on = [
#     azurerm_virtual_hub.vhub-asia
#   ]

#   tags = local.common_tags

# }

# ASIA HUB Route Table
# ASIA vHUB to ASIA Secured VNET Route
resource "azurerm_virtual_hub_route_table_route" "asia-fwroute-default" {
  route_table_id    = "${azurerm_virtual_hub.vhub-asia.id}/hubRouteTables/defaultRouteTable"
  name              = "all${var.asia_networking_core_location}-to-nva${var.asia_networking_core_location}" 
  destinations_type = "CIDR"
  destinations      = ["${var.address_space}.4.0/22"] 
  next_hop_type     = "ResourceId"
  next_hop          = azurerm_virtual_hub_connection.vhubconct-secasia-vnet.id
  depends_on = [
    azurerm_virtual_hub.vhub-asia,
    # azurerm_vpn_gateway.vpn-hub-eu-gw, # <-- If using VPN Gateway
    # azurerm_vpn_gateway.vpn-hub-asia-gw, # <-- If using VPN Gateway
    azurerm_virtual_hub_connection.vhubconct-secasia-vnet
  ]
}


# ASIA vHUB to EU vHUB
resource "azurerm_virtual_hub_route_table_route" "asia-eu-directional-route" {
  route_table_id    = "${azurerm_virtual_hub.vhub-asia.id}/hubRouteTables/defaultRouteTable"
  name              = "all${var.asia_networking_core_location}-to-nva${var.eu_networking_core_location}" 
  destinations_type = "CIDR"
  destinations      = ["${var.address_space}.8.0/22"] 
  next_hop_type     = "ResourceId"
  next_hop          = azurerm_virtual_hub_connection.vhubconct-seceu-vnet.id
  depends_on = [
    azurerm_virtual_hub.vhub-asia,
    azurerm_virtual_hub.vhub-eu,
    # azurerm_vpn_gateway.vpn-hub-eu-gw, # <-- If using VPN Gateway
    # azurerm_vpn_gateway.vpn-hub-asia-gw, # <-- If using VPN Gateway
    azurerm_virtual_hub_route_table_route.asia-fwroute-default
  ]

}

# ASIA vHUB to ASIA Secured VNET Connection
resource "azurerm_virtual_hub_connection" "vhubconct-secasia-vnet" {
  name                      = "${var.asia_networking_core_location}-vhubconct-seceu-vnet"
  virtual_hub_id            = azurerm_virtual_hub.vhub-asia.id
  remote_virtual_network_id = azurerm_virtual_network.asiasec-nvavnet.id
  internet_security_enabled = false
  routing {
    ## Below Critical to make it work as all traffic will be routed to NVA
    static_vnet_route {
      name = "all${var.asia_networking_core_location}spoke-to-nva${var.asia_networking_core_location}"
      address_prefixes = [
        "${var.address_space}.6.0/24",
        "${var.address_space}.7.0/24"
      ]
      next_hop_ip_address = azurerm_firewall.asia_firewall.ip_configuration[0].private_ip_address
    }
  }

  depends_on = [
    azurerm_virtual_hub.vhub-asia
  ]

}

################################
### CORE EU Network Components
################################
# EU vHUB
resource "azurerm_virtual_hub" "vhub-eu" {
  name                = "${var.eu_networking_core_location}-hub"
  location            = var.eu_networking_core_location
  resource_group_name = azurerm_resource_group.vwan.name
  address_prefix      = "${var.address_space}.2.0/23"
  virtual_wan_id      = azurerm_virtual_wan.wan.id
  sku                 = "Standard"

  tags = local.common_tags

}

# # EU vHUB VPN Gateway (if want to establish VPN connection to on-premises)
# resource "azurerm_vpn_gateway" "vpn-hub-eu-gw" {
#   name                = "${var.eu_networking_core_location}-vpn-gw"
#   location            = var.eu_networking_core_location
#   resource_group_name = azurerm_resource_group.vwan.name
#   virtual_hub_id      = azurerm_virtual_hub.vhub-eu.id
#   scale_unit          = 1
#   depends_on = [
#     azurerm_virtual_hub.vhub-eu
#   ]

#   tags = local.common_tags

# }

# EU HUB Route Table
resource "azurerm_virtual_hub_route_table_route" "eu-fwroute-default" {
  route_table_id    = "${azurerm_virtual_hub.vhub-eu.id}/hubRouteTables/defaultRouteTable"
  name              = "all${var.eu_networking_core_location}-to-nva${var.eu_networking_core_location}" 
  destinations_type = "CIDR"
  destinations  = ["${var.address_space}.8.0/22"] 
  next_hop_type = "ResourceId"
  next_hop      = azurerm_virtual_hub_connection.vhubconct-seceu-vnet.id
  depends_on = [
    azurerm_virtual_hub.vhub-eu,
    # azurerm_vpn_gateway.vpn-hub-eu-gw,
    # azurerm_vpn_gateway.vpn-hub-asia-gw,
    azurerm_virtual_hub_connection.vhubconct-seceu-vnet,
  ]
}

# EU vHUB to ASIA vHUB
resource "azurerm_virtual_hub_route_table_route" "eu-asia-directional-route" {
  route_table_id    = "${azurerm_virtual_hub.vhub-eu.id}/hubRouteTables/defaultRouteTable"
  name              = "all${var.eu_networking_core_location}-to-nva${var.asia_networking_core_location}" 
  destinations_type = "CIDR"
  destinations  = ["${var.address_space}.4.0/22"] 
  next_hop_type = "ResourceId"
  next_hop      = azurerm_virtual_hub_connection.vhubconct-secasia-vnet.id
  depends_on = [
    azurerm_virtual_hub.vhub-eu,
    azurerm_virtual_hub.vhub-asia,
    # azurerm_vpn_gateway.vpn-hub-eu-gw,
    # azurerm_vpn_gateway.vpn-hub-asia-gw,
    azurerm_virtual_hub_connection.vhubconct-secasia-vnet,
    azurerm_virtual_hub_route_table_route.eu-fwroute-default
  ]

}

# EU vHUB to EU Secured VNET Connection
resource "azurerm_virtual_hub_connection" "vhubconct-seceu-vnet" {
  name                      = "${var.eu_networking_core_location}-vhubconct-seceu-vnet"
  virtual_hub_id            = azurerm_virtual_hub.vhub-eu.id
  remote_virtual_network_id = azurerm_virtual_network.eusec-nvavnet.id
  internet_security_enabled = false
  routing {
    static_vnet_route {
      ## Below Critical to make it work as all traffic will be routed to NVA
      name = "all${var.eu_networking_core_location}spoke-to-nva${var.eu_networking_core_location}"
      address_prefixes = [
        "${var.address_space}.9.0/24",
        "${var.address_space}.10.0/24"
      ]
      next_hop_ip_address = azurerm_firewall.eu_firewall.ip_configuration[0].private_ip_address
    }
  }

  depends_on = [
    azurerm_virtual_hub.vhub-eu
  ]

}