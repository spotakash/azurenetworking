# SG ER GW Public IP
resource "azurerm_public_ip" "sg_gw_publicip" {
    name                = "sg_ergw_publicip"
    location            = var.sg_networking_core_location
    resource_group_name = var.sg_networking_resource_group
    allocation_method   = "Static"
    sku                 = "Standard"
    tags = {
        location = "sg"
        dept     = "networking"
    }
}

# SG ER GW
resource "azurerm_virtual_network_gateway" "sg_ergw" {
    name                = "sg_ergw"
    location            = var.sg_networking_core_location
    resource_group_name = var.sg_networking_resource_group
    type                = "ExpressRoute"
    vpn_type            = "RouteBased"
    sku                 = "Standard"
    enable_bgp          = true
    active_active       = false
    ip_configuration {
        name                          = "configuration"
        public_ip_address_id          = azurerm_public_ip.sg_gw_publicip.id
        private_ip_address_allocation = "Dynamic"
        subnet_id                     = azurerm_subnet.sg_hub_gatewaysubnet.id
    }
    tags = {
        location = "sg"
        dept     = "networking"
    }

    depends_on = [
      azurerm_public_ip.sg_gw_publicip
    ]
  
}

# # WE ER GW Public IP
# resource "azurerm_public_ip" "we_gw_publicip" {
#     name                = "we_ergw_publicip"
#     location            = var.we_networking_core_location
#     resource_group_name = var.we_networking_resource_group
#     allocation_method   = "Static"
#     sku                 = "Standard"
#     tags = {
#         location = "we"
#         dept     = "networking"
#     }
# }

# # WE ER GW
# resource "azurerm_virtual_network_gateway" "we_ergw" {
#     name                = "we_ergw"
#     location            = var.we_networking_core_location
#     resource_group_name = var.we_networking_resource_group
#     type                = "ExpressRoute"
#     vpn_type            = "RouteBased"
#     sku                 = "Standard"
#     enable_bgp          = true
#     active_active       = false
#     ip_configuration {
#         name                          = "configuration"
#         public_ip_address_id          = azurerm_public_ip.we_gw_publicip.id
#         private_ip_address_allocation = "Dynamic"
#         subnet_id                     = azurerm_subnet.we_hub_gatewaysubnet.id
#     }
#     tags = {
#         location = "we"
#         dept     = "networking"
#     }

#     depends_on = [
#       azurerm_public_ip.we_gw_publicip
#     ]
  
# }