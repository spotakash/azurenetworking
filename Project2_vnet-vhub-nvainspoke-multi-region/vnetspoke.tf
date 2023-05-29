##################################
### ASIA SPOKE Network Components
##################################

# Southeast Asia HUB Virtual Network and Subnets
resource "azurerm_resource_group" "asianetwork" {
  name     = var.asia_networking_resource_group
  location = var.asia_networking_core_location

  tags = local.common_tags
}

resource "azurerm_virtual_network" "asiasec-nvavnet" {
  name                = "Secured-NVA-VNET-Asia"
  address_space       = ["${var.address_space}.4.0/24"]
  location            = var.asia_networking_core_location
  resource_group_name = azurerm_resource_group.asianetwork.name

  tags = local.common_tags

}

resource "azurerm_subnet" "asia_AzureFirewallSubnet" {
  name                 = "AzureFirewallSubnet"
  virtual_network_name = azurerm_virtual_network.asiasec-nvavnet.name
  address_prefixes     = ["${var.address_space}.4.128/26"]
  resource_group_name  = azurerm_resource_group.asianetwork.name

}

resource "azurerm_subnet" "asia_NATGWSubnet" {
  name                 = "${var.asia_networking_core_location}-NATGw"
  virtual_network_name = azurerm_virtual_network.asiasec-nvavnet.name
  address_prefixes     = ["${var.address_space}.4.192/26"]
  resource_group_name  = azurerm_resource_group.asianetwork.name

}


# Asia Spoke 3 VNets and Subnets
resource "azurerm_virtual_network" "spoke3-vnet" {
  name                = "Asia-Spoke3"
  address_space       = ["${var.address_space}.6.0/24"]
  location            = var.asia_networking_core_location
  resource_group_name = azurerm_resource_group.asianetwork.name

  tags = local.common_tags
}

resource "azurerm_subnet" "spoke3-subnet1" {
  name                 = "spoke3-subnet1"
  virtual_network_name = azurerm_virtual_network.spoke3-vnet.name
  address_prefixes     = ["${var.address_space}.6.0/26"]
  resource_group_name  = azurerm_resource_group.asianetwork.name
}

# Asia Spoke 4 VNets and Subnets
resource "azurerm_virtual_network" "spoke4-vnet" {
  name                = "Asia-Spoke4"
  address_space       = ["${var.address_space}.7.0/24"]
  location            = var.asia_networking_core_location
  resource_group_name = azurerm_resource_group.asianetwork.name

  tags = local.common_tags

}

resource "azurerm_subnet" "spoke4-subnet1" {
  name                 = "spoke4-subnet1"
  virtual_network_name = azurerm_virtual_network.spoke4-vnet.name
  address_prefixes     = ["${var.address_space}.7.0/26"]
  resource_group_name  = azurerm_resource_group.asianetwork.name
}

# VNET Peering Spoke 3 to Asia Secured Vnet
resource "azurerm_virtual_network_peering" "spoke3-to-asiasecvnet" {
  name                         = "spoke3-to-asiasecvnet"
  resource_group_name          = azurerm_resource_group.asianetwork.name
  virtual_network_name         = azurerm_virtual_network.spoke3-vnet.name
  remote_virtual_network_id    = azurerm_virtual_network.asiasec-nvavnet.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}

# VNET Peering Spoke 4 to Secured Vnet

resource "azurerm_virtual_network_peering" "spoke4-to-asiasecvnet" {
  name                         = "spoke4-to-easiasecvnetusecvnet"
  resource_group_name          = azurerm_resource_group.asianetwork.name
  virtual_network_name         = azurerm_virtual_network.spoke4-vnet.name
  remote_virtual_network_id    = azurerm_virtual_network.asiasec-nvavnet.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}

# VNET Peering Secured Vnet to Spoke 3
resource "azurerm_virtual_network_peering" "asiasecvnet-to-spoke3" {
  name                         = "asiasecvnet-to-spoke3"
  resource_group_name          = azurerm_resource_group.asianetwork.name
  virtual_network_name         = azurerm_virtual_network.asiasec-nvavnet.name
  remote_virtual_network_id    = azurerm_virtual_network.spoke3-vnet.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}

# VNET Peering Secured Vnet to Spoke 4
resource "azurerm_virtual_network_peering" "asiasecvnet-to-spoke4" {
  name                         = "asiasecvnet-to-spoke4"
  resource_group_name          = azurerm_resource_group.asianetwork.name
  virtual_network_name         = azurerm_virtual_network.asiasec-nvavnet.name
  remote_virtual_network_id    = azurerm_virtual_network.spoke4-vnet.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}

# Asia Spoke UDR Everything to Asia NVA
resource "azurerm_route_table" "udr_to_asianva" {
  name                          = "everthing-to-${azurerm_firewall.asia_firewall.name}"
  location                      = var.asia_networking_core_location
  resource_group_name           = azurerm_resource_group.asianetwork.name
  disable_bgp_route_propagation = true

  route {
    name                   = "everthing-to-${azurerm_firewall.asia_firewall.name}"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = azurerm_firewall.asia_firewall.ip_configuration[0].private_ip_address
  }

  tags = local.common_tags
}

# Asia SPOKE Subnet UDR Association
resource "azurerm_subnet_route_table_association" "spoke3-udr" {
  subnet_id      = azurerm_subnet.spoke3-subnet1.id
  route_table_id = azurerm_route_table.udr_to_asianva.id
}

resource "azurerm_subnet_route_table_association" "spoke4-udr" {
  subnet_id      = azurerm_subnet.spoke4-subnet1.id
  route_table_id = azurerm_route_table.udr_to_asianva.id
}

##################################
### EU SPOKE Network Components
##################################
#  Europe HUB Virtual Network and Subnets

resource "azurerm_resource_group" "eunetwork" {
  name     = var.eu_networking_resource_group
  location = var.eu_networking_core_location

  tags = local.common_tags

}

resource "azurerm_virtual_network" "eusec-nvavnet" {
  name                = "Secured-NVA-VNET-EU"
  address_space       = ["${var.address_space}.8.0/24"]
  location            = var.eu_networking_core_location
  resource_group_name = azurerm_resource_group.eunetwork.name
}

resource "azurerm_subnet" "eu_AzureFirewallSubnet" {
  name                 = "AzureFirewallSubnet"
  virtual_network_name = azurerm_virtual_network.eusec-nvavnet.name
  address_prefixes     = ["${var.address_space}.8.128/26"]
  resource_group_name  = azurerm_resource_group.eunetwork.name

}

# EU Spoke 1 Vnet and Subnet
resource "azurerm_virtual_network" "spoke1-vnet" {
  name                = "EU-Spoke1"
  address_space       = ["${var.address_space}.9.0/24"]
  location            = var.eu_networking_core_location
  resource_group_name = azurerm_resource_group.eunetwork.name

  tags = local.common_tags
}

resource "azurerm_subnet" "spoke1-subnet1" {
  name                 = "spoke1-subnet1"
  virtual_network_name = azurerm_virtual_network.spoke1-vnet.name
  address_prefixes     = ["${var.address_space}.9.0/26"]
  resource_group_name  = azurerm_resource_group.eunetwork.name
}
# EU Spoke 2 Vnet and Subnet
resource "azurerm_virtual_network" "spoke2-vnet" {
  name                = "EU-Spoke2"
  address_space       = ["${var.address_space}.10.0/24"]
  location            = var.eu_networking_core_location
  resource_group_name = azurerm_resource_group.eunetwork.name

  tags = local.common_tags
}

resource "azurerm_subnet" "spoke2-subnet1" {
  name                 = "spoke2-subnet1"
  virtual_network_name = azurerm_virtual_network.spoke2-vnet.name
  address_prefixes     = ["${var.address_space}.10.0/26"]
  resource_group_name  = azurerm_resource_group.eunetwork.name
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

# EU Spoke UDR Everything to EU NVA
resource "azurerm_route_table" "udr_to_eunva" {
  name                          = "everthing-to-${azurerm_firewall.eu_firewall.name}"
  location                      = var.eu_networking_core_location
  resource_group_name           = azurerm_resource_group.eunetwork.name
  disable_bgp_route_propagation = true

  route {
    name                   = "everthing-to-${azurerm_firewall.eu_firewall.name}"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = azurerm_firewall.eu_firewall.ip_configuration[0].private_ip_address
  }

  tags = local.common_tags
}

# EU SPOKE Subnet UDR Association
resource "azurerm_subnet_route_table_association" "spoke1-udr" {
  subnet_id      = azurerm_subnet.spoke1-subnet1.id
  route_table_id = azurerm_route_table.udr_to_eunva.id
}

resource "azurerm_subnet_route_table_association" "spoke2-udr" {
  subnet_id      = azurerm_subnet.spoke2-subnet1.id
  route_table_id = azurerm_route_table.udr_to_eunva.id
}