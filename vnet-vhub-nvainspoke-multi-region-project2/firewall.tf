# Asia Firewall resource 
resource "azurerm_firewall" "asia_firewall" {
  name                = "asia_firewall"
  location            = var.asia_networking_core_location
  resource_group_name = azurerm_resource_group.asianetwork.name
  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.asia_AzureFirewallSubnet.id
    public_ip_address_id = azurerm_public_ip.asia_firewall_public_ip.id
  }
  sku_name           = "AZFW_VNet"
  sku_tier           = "Premium"
  firewall_policy_id = azurerm_firewall_policy.common_azfw_premium_policy.id # <---This can be variable of existing policy
  # zones = [ "1", "2" ] 

  tags = {
    location = "asia"
    dept     = "networking"
  }

  depends_on = [
    azurerm_subnet.asia_AzureFirewallSubnet,
    azurerm_public_ip.asia_firewall_public_ip,
    azurerm_firewall_policy.common_azfw_premium_policy
  ]
}

# SG Firewall Public IP resource
resource "azurerm_public_ip" "asia_firewall_public_ip" {
  name                = "asia_firewall_public_ip"
  location            = var.asia_networking_core_location
  resource_group_name = azurerm_resource_group.asianetwork.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags = {
    location = "asia"
    dept     = "networking"
  }
}

# EU Firewall resource 
resource "azurerm_firewall" "eu_firewall" {
  name                = "eu_firewall"
  location            = var.eu_networking_core_location
  resource_group_name = azurerm_resource_group.eunetwork.name
  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.eu_AzureFirewallSubnet.id
    public_ip_address_id = azurerm_public_ip.eu_firewall_public_ip.id
  }
  sku_name           = "AZFW_VNet"
  sku_tier           = "Premium"
  firewall_policy_id = azurerm_firewall_policy.common_azfw_premium_policy.id # <---This can be variable of existing policy
  # zones = [ "1", "2" ] 

  tags = {
    location = "eu"
    dept     = "networking"
  }

  depends_on = [
    azurerm_subnet.eu_AzureFirewallSubnet,
    azurerm_public_ip.eu_firewall_public_ip,
    azurerm_firewall_policy.common_azfw_premium_policy
  ]
}

# SG Firewall Public IP resource
resource "azurerm_public_ip" "eu_firewall_public_ip" {
  name                = "eu_firewall_public_ip"
  location            = var.eu_networking_core_location
  resource_group_name = azurerm_resource_group.eunetwork.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags = {
    location = "eu"
    dept     = "networking"
  }
}