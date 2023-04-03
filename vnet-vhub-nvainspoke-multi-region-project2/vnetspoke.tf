# Southeast Asia HUB Virtual Network and Subnets
resource "azurerm_resource_group" "asianetwork" {
  name     = var.asia_networking_resource_group
  location = var.asia_networking_core_location
}

resource "azurerm_virtual_network" "asiasec-nvavnet" {
  name                = "Secured-NVA-VNET-Asia"
  address_space       = ["${var.address_space}.4.128/25"]
  location            = var.asia_networking_core_location
  resource_group_name = azurerm_resource_group.asianetwork.name
}

resource "azurerm_subnet" "asia_AzureFirewallSubnet" {
  name                 = "AzureFirewallSubnet"
  virtual_network_name = azurerm_virtual_network.asiasec-nvavnet.name
  address_prefixes     = ["${var.address_space}.4.128/26"]
  resource_group_name  = azurerm_resource_group.asianetwork.name
}


# Asia Spoke 3 Vnet and Spoke 4 Vnet
resource "azurerm_virtual_network" "spoke3-vnet" {
  name                = "Asia-Spoke3"
  address_space       = ["${var.address_space}.7.0/24"]
  location            = var.asia_networking_core_location
  resource_group_name = azurerm_resource_group.asianetwork.name
}

resource "azurerm_virtual_network" "spoke4-vnet" {
  name                = "Asia-Spoke4"
  address_space       = ["${var.address_space}.8.0/24"]
  location            = var.asia_networking_core_location
  resource_group_name = azurerm_resource_group.asianetwork.name
}


#  Europe HUB Virtual Network and Subnets

resource "azurerm_resource_group" "eunetwork" {
  name     = var.eu_networking_core_location
  location = var.eu_networking_core_location
}

resource "azurerm_virtual_network" "eusec-nvavnet" {
  name                = "Secured-NVA-VNET-EU"
  address_space       = ["${var.address_space}.4.0/25"]
  location            = var.eu_networking_core_location
  resource_group_name = azurerm_resource_group.eunetwork.name
}

resource "azurerm_subnet" "eu_AzureFirewallSubnet" {
  name                 = "AzureFirewallSubnet"
  virtual_network_name = azurerm_virtual_network.eusec-nvavnet.name
  address_prefixes     = ["${var.address_space}.4.0/26"]
  resource_group_name  = azurerm_resource_group.eunetwork.name
}

# EU Spoke 1 Vnet and Spoke 2 Vnet
resource "azurerm_virtual_network" "spoke1-vnet" {
  name                = "EU-Spoke1"
  address_space       = ["${var.address_space}.5.0/24"]
  location            = var.eu_networking_core_location
  resource_group_name = azurerm_resource_group.eunetwork.name
}

resource "azurerm_virtual_network" "spoke2-vnet" {
  name                = "EU-Spoke2"
  address_space       = ["${var.address_space}.6.0/24"]
  location            = var.eu_networking_core_location
  resource_group_name = azurerm_resource_group.eunetwork.name
}

# VNET Peering Spoke 1 to Secured Vnet
resource "azurerm_virtual_network_peering" "spoke1-to-eusecvnet" {
  name                         = "spoke1-to-eusecvnet"
  resource_group_name          = azurerm_resource_group.eunetwork.name
  virtual_network_name         = azurerm_virtual_network.spoke1-vnet.name
  remote_virtual_network_id    = azurerm_virtual_network.eusec-nvavnet.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}

# VNET Peering Spoke 2 to Secured Vnet

resource "azurerm_virtual_network_peering" "spoke2-to-eusecvnet" {
  name                         = "spoke2-to-eusecvnet"
  resource_group_name          = azurerm_resource_group.eunetwork.name
  virtual_network_name         = azurerm_virtual_network.spoke2-vnet.name
  remote_virtual_network_id    = azurerm_virtual_network.eusec-nvavnet.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}

# VNET Peering Secured Vnet to Spoke 1
resource "azurerm_virtual_network_peering" "eusecvnet-to-spoke1" {
  name                         = "eusecvnet-to-spoke1"
  resource_group_name          = azurerm_resource_group.eunetwork.name
  virtual_network_name         = azurerm_virtual_network.eusec-nvavnet.name
  remote_virtual_network_id    = azurerm_virtual_network.spoke1-vnet.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}

# VNET Peering Secured Vnet to Spoke 2
resource "azurerm_virtual_network_peering" "eusecvnet-to-spoke2" {
  name                         = "eusecvnet-to-spoke3"
  resource_group_name          = azurerm_resource_group.eunetwork.name
  virtual_network_name         = azurerm_virtual_network.eusec-nvavnet.name
  remote_virtual_network_id    = azurerm_virtual_network.spoke2-vnet.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}




# # VNET HUB to HUB Peering
# resource "azurerm_virtual_network_peering" "sghub_to_wehub_peering" {
#   name                         = "sghub_to_wehub_peering"
#   resource_group_name          = azurerm_resource_group.sg_hub_resource_group.name
#   virtual_network_name         = azurerm_virtual_network.sg_hub_vnet.name
#   remote_virtual_network_id    = azurerm_virtual_network.we_hub_vnet.id
#   allow_virtual_network_access = true
#   allow_forwarded_traffic      = true
# }

# resource "azurerm_virtual_network_peering" "wehub_to_sghub_peering" {
#   name                         = "wehub_to_sghub_peering"
#   resource_group_name          = azurerm_resource_group.we_hub_resource_group.name
#   virtual_network_name         = azurerm_virtual_network.we_hub_vnet.name
#   remote_virtual_network_id    = azurerm_virtual_network.sg_hub_vnet.id
#   allow_virtual_network_access = true
#   allow_forwarded_traffic      = true
# }

# # SG VNET HUB to SG VNET Spoke Peering
# resource "azurerm_virtual_network_peering" "sg_hub_to_sg_spoke_peering" {
#   for_each                     = var.sg_spoke_vnet
#   name                         = "sg_hub_peering_to_${each.value["name"]}"
#   resource_group_name          = azurerm_resource_group.sg_hub_resource_group.name
#   virtual_network_name         = azurerm_virtual_network.sg_hub_vnet.name
#   remote_virtual_network_id    = each.value["vnet_id"]
#   allow_virtual_network_access = true
#   allow_forwarded_traffic      = true
#   allow_gateway_transit        = true

#   depends_on = [
#     azurerm_virtual_network_gateway.sg_ergw
#   ]
# }

# # SG SPOKE to SG VNET HUB Peering
# resource "azurerm_virtual_network_peering" "sg_spoke_to_sg_hub_peering" {
#   for_each                     = var.sg_spoke_vnet
#   name                         = "${each.value["name"]}_to_sg_hub_peering"
#   resource_group_name          = each.value["spoke_rg"]
#   virtual_network_name         = each.value["name"]
#   remote_virtual_network_id    = azurerm_virtual_network.sg_hub_vnet.id
#   allow_virtual_network_access = true
#   allow_forwarded_traffic      = true
#   use_remote_gateways          = true

#   depends_on = [
#     azurerm_virtual_network_gateway.sg_ergw
#   ]
# }

# # WE VNET HUB to WE VNET Spoke Peering
# resource "azurerm_virtual_network_peering" "we_hub_to_we_spoke_peering" {
#   for_each                     = var.we_spoke_vnet
#   name                         = "we_hub_peering_to_${each.value["name"]}"
#   resource_group_name          = azurerm_resource_group.we_hub_resource_group.name
#   virtual_network_name         = azurerm_virtual_network.we_hub_vnet.name
#   remote_virtual_network_id    = each.value["vnet_id"]
#   allow_virtual_network_access = true
#   allow_forwarded_traffic      = true
#   # allow_gateway_transit        = true # <-- This is require if GW is in the same VNET

#   # depends_on = [
#   #   azurerm_virtual_network_gateway.we_ergw
#   # ]
# }

# # WE SPOKE to WE VNET HUB Peering
# resource "azurerm_virtual_network_peering" "we_spoke_to_we_hub_peering" {
#   for_each                     = var.we_spoke_vnet
#   name                         = "${each.value["name"]}_to_we_hub_peering"
#   resource_group_name          = each.value["spoke_rg"]
#   virtual_network_name         = each.value["name"]
#   remote_virtual_network_id    = azurerm_virtual_network.we_hub_vnet.id
#   allow_virtual_network_access = true
#   allow_forwarded_traffic      = true
#   # use_remote_gateways          = true # <-- This is require if GW is in the same VNET
# }