# Virtual WAN and vHUB Resources
resource "azurerm_resource_group" "vwan" {
  name     = "cgy-wan"
  location = var.primary_location_asia
}

# Core vWAN
resource "azurerm_virtual_wan" "wan" {
  name                           = "pd-wan"
  resource_group_name            = azurerm_resource_group.vwan.name
  location                       = var.primary_location_asia
  allow_branch_to_branch_traffic = true
  type                           = "Standard"

}

# Asia vHUB
resource "azurerm_virtual_hub" "vhub-asia" {
  name                = "sea-vhub"
  location            = var.primary_location_asia
  resource_group_name = azurerm_resource_group.vwan.name
  address_prefix      = "${var.address_space}.0.0/23"
  virtual_wan_id      = azurerm_virtual_wan.wan.id
  sku                 = "Standard"
}

# Asia vHUB to Asia Spoke VNET Connection
resource "azurerm_virtual_hub_connection" "asiahub-to-asiaspokevnet1" {
  name                      = "asiahub-to-asiaspokevnet1"
  virtual_hub_id            = azurerm_virtual_hub.vhub-asia.id
  remote_virtual_network_id = azurerm_virtual_network.asia-vnet1.id
}

# # EU vHUB
# resource "azurerm_virtual_hub" "vhub-eu" {
#   name                = "eu-vhub"
#   location            = var.primary_location_eu
#   resource_group_name = azurerm_resource_group.vwan.name
#   address_prefix      = "${var.address_space}.2.0/23"
#   virtual_wan_id      = azurerm_virtual_wan.wan.id
#   sku                 = "Standard"
# }

# # EU vHUB to EU SeSpoke VNET Connection
# resource "azurerm_virtual_hub_connection" "euhub-to-euspokevnet1" {
#   name                      = "euhub-to-euspokevnet1"
#   virtual_hub_id            = azurerm_virtual_hub.vhub-eu.id
#   remote_virtual_network_id = azurerm_virtual_network.eu-vnet1.id
# }