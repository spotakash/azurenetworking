resource "azurerm_vpn_gateway" "asia_vpngw" {
  name                = "asia-vpngw"
  location            = var.primary_location_asia
  resource_group_name = azurerm_resource_group.vwan.name
  virtual_hub_id      = azurerm_virtual_hub.vhub-asia.id
}

# resource "azurerm_vpn_site" "vpn1_asia_gcp" {
#     name = "vpn1_asia_gcp"
#     resource_group_name = azurerm_resource_group.vwan.name
#     location = var.primary_location_asia
#     virtual_wan_id = azurerm_virtual_wan.vwan.id
#     address_cidrs = [ "10.0.0.0/24" ]
#     device_model = "branch1-model"
#     device_vendor = "branch1-device"
#     link {
#       name = link1-branch1-sea
#       ip_address = 
#       speed_in_mbps = "100"
#     }

# }