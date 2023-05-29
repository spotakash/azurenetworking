resource "azurerm_resource_group" "nat-asia" {
  name     = "${var.asia_networking_core_location}-nat-rg"
  location = var.asia_networking_core_location

  tags = local.common_tags

}

resource "azurerm_public_ip" "nat-asia" {
  name                = "${var.asia_networking_core_location}-nat-pip"
  location            = azurerm_resource_group.nat-asia.location
  resource_group_name = azurerm_resource_group.nat-asia.name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = ["1"]

  tags = local.common_tags

}

resource "azurerm_public_ip_prefix" "nat-asia" {
  name                = "${var.asia_networking_core_location}-pubip"
  location            = azurerm_resource_group.nat-asia.location
  resource_group_name = azurerm_resource_group.nat-asia.name
  prefix_length       = 30
  zones               = ["1"]

  tags = local.common_tags

}

resource "azurerm_nat_gateway" "nat-asia" {
  name                    = "${var.asia_networking_core_location}-natgw"
  location                = azurerm_resource_group.nat-asia.location
  resource_group_name     = azurerm_resource_group.nat-asia.name
  sku_name                = "Standard"
  idle_timeout_in_minutes = 10
  zones                   = ["1"]

  tags = local.common_tags

}

resource "azurerm_subnet_nat_gateway_association" "nat-asia" {
  subnet_id      = azurerm_subnet.asia_AzureFirewallSubnet.id
  nat_gateway_id = azurerm_nat_gateway.nat-asia.id
}

resource "azurerm_nat_gateway_public_ip_association" "nat-asia" {
  nat_gateway_id       = azurerm_nat_gateway.nat-asia.id
  public_ip_address_id = azurerm_public_ip.nat-asia.id
}