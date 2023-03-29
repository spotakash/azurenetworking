# SG Firewall resource 
resource "azurerm_firewall" "sg_firewall" {
  name                = "sg_firewall"
  location            = var.sg_networking_core_location
  resource_group_name = var.sg_networking_resource_group
  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.sg_AzureFirewallSubnet.id
    public_ip_address_id = azurerm_public_ip.sg_firewall_public_ip.id
  }
  sku_name           = "AZFW_VNet"
  sku_tier           = "Premium"
  firewall_policy_id = azurerm_firewall_policy.common_azfw_premium_policy.id # <---This can be variable of existing policy
  # zones = [ "1", "2" ]

  tags = {
    location = "sg"
    dept     = "networking"
  }

  depends_on = [
    azurerm_subnet.sg_AzureFirewallSubnet,
    azurerm_public_ip.sg_firewall_public_ip,
    azurerm_firewall_policy.common_azfw_premium_policy
  ]
}

# SG Firewall Public IP resource
resource "azurerm_public_ip" "sg_firewall_public_ip" {
  name                = "sg_firewall_public_ip"
  location            = var.sg_networking_core_location
  resource_group_name = var.sg_networking_resource_group
  allocation_method   = "Static"
  sku                 = "Standard"
  tags = {
    location = "sg"
    dept     = "networking"
  }
}

# WE Firewall resource 
resource "azurerm_firewall" "we_firewall" {
  name                = "we_firewall"
  location            = var.we_networking_core_location
  resource_group_name = var.we_networking_resource_group
  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.we_AzureFirewallSubnet.id
    public_ip_address_id = azurerm_public_ip.we_firewall_public_ip.id
  }
  sku_name           = "AZFW_VNet"
  sku_tier           = "Premium"
  firewall_policy_id = azurerm_firewall_policy.common_azfw_premium_policy.id # <---This can be variable of existing policy
  # zones = [ "1", "2" ]

  tags = {
    location = "sg"
    dept     = "networking"
  }

  depends_on = [
    azurerm_subnet.we_AzureFirewallSubnet,
    azurerm_public_ip.we_firewall_public_ip,
    azurerm_firewall_policy.common_azfw_premium_policy
  ]
}

# WE Firewall Public IP resource
resource "azurerm_public_ip" "we_firewall_public_ip" {
  name                = "we_firewall_public_ip"
  location            = var.we_networking_core_location
  resource_group_name = var.we_networking_resource_group
  allocation_method   = "Static"
  sku                 = "Standard"
  tags = {
    location = "sg"
    dept     = "networking"
  }
}
