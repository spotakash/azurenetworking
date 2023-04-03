# Virtual WAN and vHUB Resources
resource "azurerm_resource_group" "vwan" {
  name     = "cgy-wan"
  location = var.asia_networking_core_location
}

# Core vWAN
resource "azurerm_virtual_wan" "wan" {
  name                           = "cgy-wan"
  resource_group_name            = azurerm_resource_group.vwan.name
  location                       = var.asia_networking_core_location
  allow_branch_to_branch_traffic = true
  type                           = "Standard"

}

# Asia vHUB
resource "azurerm_virtual_hub" "vhub-asia" {
  name                = "sea-vhub"
  location            = var.asia_networking_core_location
  resource_group_name = azurerm_resource_group.vwan.name
  address_prefix      = "${var.address_space}.0.0/23"
  virtual_wan_id      = azurerm_resource_group.wan.id
  sku                 = "Standard"
}

# Asia vHUB to Asia Secured VNET Connection
resource "azurerm_virtual_hub_connection" "asiahub-to-asiasecvnet" {
  name                      = "asiahub-to-asiasecvnet"
  virtual_hub_id            = azurerm_virtual_hub.vhub-asia.id
  remote_virtual_network_id = azurerm_virtual_network.asiasec-nvavnet.id
}

# EU vHUB
resource "azurerm_virtual_hub" "vhub-eu" {
  name                = "eu-vhub"
  location            = var.eu_networking_core_location
  resource_group_name = azurerm_resource_group.vwan.name
  address_prefix      = "${var.address_space}.2.0/23"
  virtual_wan_id      = azurerm_resource_group.wan.id
  sku                 = "Standard"
}

# EU vHUB to EU Secured VNET Connection
resource "azurerm_virtual_hub_connection" "euhub-to-eusecvnet" {
  name                      = "euhub-to-eusecvnet"
  virtual_hub_id            = azurerm_virtual_hub.vhub-eu.id
  remote_virtual_network_id = azurerm_virtual_network.eusec-nvavnet.id
}