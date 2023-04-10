# Southeast Asia HUB Virtual Network and Subnets
resource "azurerm_resource_group" "sg_hub_resource_group" {
  name     = var.sg_networking_resource_group
  location = var.sg_networking_core_location
  tags     = local.common_tags
}

resource "azurerm_virtual_network" "sg_hub_vnet" {
  name                = "SEA-HUB-VNET"
  address_space       = ["${var.address_space}.0.0/22"]
  location            = var.sg_networking_core_location
  resource_group_name = azurerm_resource_group.sg_hub_resource_group.name
}

resource "azurerm_subnet" "sg_hub_gatewaysubnet" {
  name                 = "GatewaySubnet"
  virtual_network_name = azurerm_virtual_network.sg_hub_vnet.name
  address_prefixes     = ["${var.address_space}.0.0/26"]
  resource_group_name  = azurerm_resource_group.sg_hub_resource_group.name
}

resource "azurerm_subnet" "sg_hub_nva" {
  name                 = "nva"
  virtual_network_name = azurerm_virtual_network.sg_hub_vnet.name
  address_prefixes     = ["${var.address_space}.0.64/26"]
  resource_group_name  = azurerm_resource_group.sg_hub_resource_group.name
}

resource "azurerm_subnet" "sg_AzureFirewallSubnet" {
  name                 = "AzureFirewallSubnet"
  virtual_network_name = azurerm_virtual_network.sg_hub_vnet.name
  address_prefixes     = ["${var.address_space}.0.128/26"]
  resource_group_name  = azurerm_resource_group.sg_hub_resource_group.name
}

resource "azurerm_subnet" "sg_RouteServerSubnet" {
  name                 = "RouteServerSubnet"
  virtual_network_name = azurerm_virtual_network.sg_hub_vnet.name
  address_prefixes     = ["${var.address_space}.0.192/26"]
  resource_group_name  = azurerm_resource_group.sg_hub_resource_group.name
}

resource "azurerm_subnet" "sg_AzureBastionSubnet" {
  name                 = "AzureBastionSubnet"
  virtual_network_name = azurerm_virtual_network.sg_hub_vnet.name
  address_prefixes     = ["${var.address_space}.1.0/26"]
  resource_group_name  = azurerm_resource_group.sg_hub_resource_group.name
}

# West Europe HUB Virtual Network and Subnets

resource "azurerm_resource_group" "we_hub_resource_group" {
  name     = var.we_networking_resource_group
  location = var.we_networking_core_location
  tags     = local.common_tags
}

resource "azurerm_virtual_network" "we_hub_vnet" {
  name                = "WEU-HUB-VNET"
  address_space       = ["${var.address_space}.4.0/22"]
  location            = var.we_networking_core_location
  resource_group_name = azurerm_resource_group.we_hub_resource_group.name
}

resource "azurerm_subnet" "we_hub_gatewaysubnet" {
  name                 = "GatewaySubnet"
  virtual_network_name = azurerm_virtual_network.we_hub_vnet.name
  address_prefixes     = ["${var.address_space}.4.0/26"]
  resource_group_name  = azurerm_resource_group.we_hub_resource_group.name
}

resource "azurerm_subnet" "we_hub_nva" {
  name                 = "nva"
  virtual_network_name = azurerm_virtual_network.we_hub_vnet.name
  address_prefixes     = ["${var.address_space}.4.64/26"]
  resource_group_name  = azurerm_resource_group.we_hub_resource_group.name
}

resource "azurerm_subnet" "we_AzureFirewallSubnet" {
  name                 = "AzureFirewallSubnet"
  virtual_network_name = azurerm_virtual_network.we_hub_vnet.name
  address_prefixes     = ["${var.address_space}.4.128/26"]
  resource_group_name  = azurerm_resource_group.we_hub_resource_group.name
}

resource "azurerm_subnet" "we_RouteServerSubnet" {
  name                 = "RouteServerSubnet"
  virtual_network_name = azurerm_virtual_network.we_hub_vnet.name
  address_prefixes     = ["${var.address_space}.4.192/26"]
  resource_group_name  = azurerm_resource_group.we_hub_resource_group.name
}

resource "azurerm_subnet" "we_AzureBastionSubnet" {
  name                 = "AzureBastionSubnet"
  virtual_network_name = azurerm_virtual_network.we_hub_vnet.name
  address_prefixes     = ["${var.address_space}.5.0/26"]
  resource_group_name  = azurerm_resource_group.we_hub_resource_group.name
}

# VNET HUB to HUB Peering
resource "azurerm_virtual_network_peering" "sghub_to_wehub_peering" {
  name                         = "sghub_to_wehub_peering"
  resource_group_name          = azurerm_resource_group.sg_hub_resource_group.name
  virtual_network_name         = azurerm_virtual_network.sg_hub_vnet.name
  remote_virtual_network_id    = azurerm_virtual_network.we_hub_vnet.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}

resource "azurerm_virtual_network_peering" "wehub_to_sghub_peering" {
  name                         = "wehub_to_sghub_peering"
  resource_group_name          = azurerm_resource_group.we_hub_resource_group.name
  virtual_network_name         = azurerm_virtual_network.we_hub_vnet.name
  remote_virtual_network_id    = azurerm_virtual_network.sg_hub_vnet.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}

# SG VNET HUB to SG VNET Spoke Peering
resource "azurerm_virtual_network_peering" "sg_hub_to_sg_spoke_peering" {
  for_each                     = var.sg_spoke_vnet
  name                         = "sg_hub_peering_to_${each.value["name"]}"
  resource_group_name          = azurerm_resource_group.sg_hub_resource_group.name
  virtual_network_name         = azurerm_virtual_network.sg_hub_vnet.name
  remote_virtual_network_id    = each.value["vnet_id"]
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = true

  depends_on = [
    azurerm_virtual_network_gateway.sg_ergw
  ]
}

# SG SPOKE to SG VNET HUB Peering
resource "azurerm_virtual_network_peering" "sg_spoke_to_sg_hub_peering" {
  for_each                     = var.sg_spoke_vnet
  name                         = "${each.value["name"]}_to_sg_hub_peering"
  resource_group_name          = each.value["spoke_rg"]
  virtual_network_name         = each.value["name"]
  remote_virtual_network_id    = azurerm_virtual_network.sg_hub_vnet.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  use_remote_gateways          = true

  depends_on = [
    azurerm_virtual_network_gateway.sg_ergw
  ]
}

# WE VNET HUB to WE VNET Spoke Peering
resource "azurerm_virtual_network_peering" "we_hub_to_we_spoke_peering" {
  for_each                     = var.we_spoke_vnet
  name                         = "we_hub_peering_to_${each.value["name"]}"
  resource_group_name          = azurerm_resource_group.we_hub_resource_group.name
  virtual_network_name         = azurerm_virtual_network.we_hub_vnet.name
  remote_virtual_network_id    = each.value["vnet_id"]
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  # allow_gateway_transit        = true # <-- This is require if GW is in the same VNET

  # depends_on = [
  #   azurerm_virtual_network_gateway.we_ergw
  # ]
}

# WE SPOKE to WE VNET HUB Peering
resource "azurerm_virtual_network_peering" "we_spoke_to_we_hub_peering" {
  for_each                     = var.we_spoke_vnet
  name                         = "${each.value["name"]}_to_we_hub_peering"
  resource_group_name          = each.value["spoke_rg"]
  virtual_network_name         = each.value["name"]
  remote_virtual_network_id    = azurerm_virtual_network.we_hub_vnet.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  # use_remote_gateways          = true # <-- This is require if GW is in the same VNET
}