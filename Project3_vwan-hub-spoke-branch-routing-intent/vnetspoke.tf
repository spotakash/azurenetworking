# # Southeast Asia HUB Virtual Network and Subnets
# resource "azurerm_resource_group" "asianetwork" {
#   name     = var.asia_networking_resource_group
#   location = var.asia_networking_core_location
# }

# resource "azurerm_virtual_network" "asiasec-nvavnet" {
#   name                = "Secured-NVA-VNET-Asia"
#   address_space       = ["${var.address_space}.4.128/25"]
#   location            = var.asia_networking_core_location
#   resource_group_name = azurerm_resource_group.asianetwork.name
# }

# resource "azurerm_subnet" "asia_AzureFirewallSubnet" {
#   name                 = "AzureFirewallSubnet"
#   virtual_network_name = azurerm_virtual_network.asiasec-nvavnet.name
#   address_prefixes     = ["${var.address_space}.4.128/26"]
#   resource_group_name  = azurerm_resource_group.asianetwork.name
# }


# # Asia Spoke 1 Vnet and Spoke 2 Vnet
# resource "azurerm_virtual_network" "spoke1-vnet" {
#   name                = "Asia-Spoke1"
#   address_space       = ["${var.address_space}.7.0/24"]
#   location            = var.asia_networking_core_location
#   resource_group_name = azurerm_resource_group.asianetwork.name
# }

# resource "azurerm_virtual_network" "spoke2-vnet" {
#   name                = "Asia-Spoke2"
#   address_space       = ["${var.address_space}.8.0/24"]
#   location            = var.asia_networking_core_location
#   resource_group_name = azurerm_resource_group.asianetwork.name
# }

# # VNET Peering Spoke 3 to Secured Vnet
# resource "azurerm_virtual_network_peering" "spoke3-to-asiasecvnet" {
#   name                         = "spoke3-to-asiasecvnet"
#   resource_group_name          = azurerm_resource_group.asianetwork.name
#   virtual_network_name         = azurerm_virtual_network.spoke3-vnet.name
#   remote_virtual_network_id    = azurerm_virtual_network.asiasec-nvavnet.id
#   allow_virtual_network_access = true
#   allow_forwarded_traffic      = true
# }

# # VNET Peering Spoke 4 to Secured Vnet

# resource "azurerm_virtual_network_peering" "spoke4-to-asiasecvnet" {
#   name                         = "spoke4-to-easiasecvnetusecvnet"
#   resource_group_name          = azurerm_resource_group.asianetwork.name
#   virtual_network_name         = azurerm_virtual_network.spoke4-vnet.name
#   remote_virtual_network_id    = azurerm_virtual_network.asiasec-nvavnet.id
#   allow_virtual_network_access = true
#   allow_forwarded_traffic      = true
# }

# # VNET Peering Secured Vnet to Spoke 3
# resource "azurerm_virtual_network_peering" "asiasecvnet-to-spoke3" {
#   name                         = "asiasecvnet-to-spoke3"
#   resource_group_name          = azurerm_resource_group.asianetwork.name
#   virtual_network_name         = azurerm_virtual_network.asiasec-nvavnet.name
#   remote_virtual_network_id    = azurerm_virtual_network.spoke3-vnet.id
#   allow_virtual_network_access = true
#   allow_forwarded_traffic      = true
# }

# # VNET Peering Secured Vnet to Spoke 4
# resource "azurerm_virtual_network_peering" "asiasecvnet-to-spoke4" {
#   name                         = "asiasecvnet-to-spoke4"
#   resource_group_name          = azurerm_resource_group.asianetwork.name
#   virtual_network_name         = azurerm_virtual_network.asiasec-nvavnet.name
#   remote_virtual_network_id    = azurerm_virtual_network.spoke4-vnet.id
#   allow_virtual_network_access = true
#   allow_forwarded_traffic      = true
# }



# #  Europe HUB Virtual Network and Subnets

# resource "azurerm_resource_group" "eunetwork" {
#   name     = var.eu_networking_resource_group
#   location = var.eu_networking_core_location
# }

# resource "azurerm_virtual_network" "eusec-nvavnet" {
#   name                = "Secured-NVA-VNET-EU"
#   address_space       = ["${var.address_space}.4.0/25"]
#   location            = var.eu_networking_core_location
#   resource_group_name = azurerm_resource_group.eunetwork.name
# }

# resource "azurerm_subnet" "eu_AzureFirewallSubnet" {
#   name                 = "AzureFirewallSubnet"
#   virtual_network_name = azurerm_virtual_network.eusec-nvavnet.name
#   address_prefixes     = ["${var.address_space}.4.0/26"]
#   resource_group_name  = azurerm_resource_group.eunetwork.name
# }

# # EU Spoke 1 Vnet and Spoke 2 Vnet
# resource "azurerm_virtual_network" "spoke1-vnet" {
#   name                = "EU-Spoke1"
#   address_space       = ["${var.address_space}.5.0/24"]
#   location            = var.eu_networking_core_location
#   resource_group_name = azurerm_resource_group.eunetwork.name
# }

# resource "azurerm_virtual_network" "spoke2-vnet" {
#   name                = "EU-Spoke2"
#   address_space       = ["${var.address_space}.6.0/24"]
#   location            = var.eu_networking_core_location
#   resource_group_name = azurerm_resource_group.eunetwork.name
# }

# # VNET Peering Spoke 1 to Secured Vnet
# resource "azurerm_virtual_network_peering" "spoke1-to-eusecvnet" {
#   name                         = "spoke1-to-eusecvnet"
#   resource_group_name          = azurerm_resource_group.eunetwork.name
#   virtual_network_name         = azurerm_virtual_network.spoke1-vnet.name
#   remote_virtual_network_id    = azurerm_virtual_network.eusec-nvavnet.id
#   allow_virtual_network_access = true
#   allow_forwarded_traffic      = true
# }

# # VNET Peering Spoke 2 to Secured Vnet

# resource "azurerm_virtual_network_peering" "spoke2-to-eusecvnet" {
#   name                         = "spoke2-to-eusecvnet"
#   resource_group_name          = azurerm_resource_group.eunetwork.name
#   virtual_network_name         = azurerm_virtual_network.spoke2-vnet.name
#   remote_virtual_network_id    = azurerm_virtual_network.eusec-nvavnet.id
#   allow_virtual_network_access = true
#   allow_forwarded_traffic      = true
# }

# # VNET Peering Secured Vnet to Spoke 1
# resource "azurerm_virtual_network_peering" "eusecvnet-to-spoke1" {
#   name                         = "eusecvnet-to-spoke1"
#   resource_group_name          = azurerm_resource_group.eunetwork.name
#   virtual_network_name         = azurerm_virtual_network.eusec-nvavnet.name
#   remote_virtual_network_id    = azurerm_virtual_network.spoke1-vnet.id
#   allow_virtual_network_access = true
#   allow_forwarded_traffic      = true
# }

# # VNET Peering Secured Vnet to Spoke 2
# resource "azurerm_virtual_network_peering" "eusecvnet-to-spoke2" {
#   name                         = "eusecvnet-to-spoke3"
#   resource_group_name          = azurerm_resource_group.eunetwork.name
#   virtual_network_name         = azurerm_virtual_network.eusec-nvavnet.name
#   remote_virtual_network_id    = azurerm_virtual_network.spoke2-vnet.id
#   allow_virtual_network_access = true
#   allow_forwarded_traffic      = true
# }

# Asia Spoke Vnet
resource "azurerm_resource_group" "asia-vnet" {
  name     = "asia-spoke-vnets"
  location = var.primary_location_asia
  tags     = local.common_tags
}

resource "azurerm_virtual_network" "asia-vnet1" {
  name                = "asia-vnet1"
  address_space       = ["${var.address_space}.7.0/24"]
  location            = var.primary_location_asia
  resource_group_name = azurerm_resource_group.asia-vnet.name
  tags                = local.common_tags
}

resource "azurerm_subnet" "asia-vnet1-subnets" {
  for_each             = var.vnet1_subnets_asia
  resource_group_name  = azurerm_resource_group.asia-vnet.name
  virtual_network_name = azurerm_virtual_network.asia-vnet1.name
  name                 = each.value["name"]
  address_prefixes     = each.value["subnet_address_prefixes"]
}

# EU Spoke Vnet
resource "azurerm_resource_group" "eu-vnet" {
  name     = "eu-spoke-vnets"
  location = var.primary_location_eu
  tags     = local.common_tags
}

resource "azurerm_virtual_network" "eu-vnet1" {
  name                = "eu-vnet1"
  address_space       = ["${var.address_space}.5.0/24"]
  location            = var.primary_location_eu
  resource_group_name = azurerm_resource_group.eu-vnet.name
  tags                = local.common_tags
}

resource "azurerm_subnet" "eu-vnet1-subnets" {
  for_each             = var.vnet1_subnets_eu
  resource_group_name  = azurerm_resource_group.eu-vnet.name
  virtual_network_name = azurerm_virtual_network.eu-vnet1.name
  name                 = each.value["name"]
  address_prefixes     = each.value["subnet_address_prefixes"]
}

