##################################
### ASIA NVA (AzFW) Components
##################################
# Asia Firewall resource 
resource "azurerm_firewall" "asia_firewall" {
  name                = "${var.asia_networking_core_location}-fw"
  location            = var.asia_networking_core_location
  resource_group_name = azurerm_resource_group.asianetwork.name
  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.asia_AzureFirewallSubnet.id
    public_ip_address_id = azurerm_public_ip.asia_firewall_public_ip.id
  }
  sku_name           = "AZFW_VNet"
  sku_tier           = var.firewallandpolicysku
  firewall_policy_id = azurerm_firewall_policy.asia-azfw_premium_policy.id # <---This can be variable of existing policy
  # zones = [ "1", "2" ] # <---Depending upon your requirement

  depends_on = [
    azurerm_subnet.asia_AzureFirewallSubnet,
    azurerm_public_ip.asia_firewall_public_ip,
    azurerm_firewall_policy.asia-azfw_premium_policy
  ]

  tags = local.common_tags

}

# ASIA Firewall Public IP resource
resource "azurerm_public_ip" "asia_firewall_public_ip" {
  name                = "${var.asia_networking_core_location}-fw-pip"
  location            = var.asia_networking_core_location
  resource_group_name = azurerm_resource_group.asianetwork.name
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = local.common_tags

}

##################################
### EU NVA (AzFw) Components
##################################
# EU Firewall resource 
resource "azurerm_firewall" "eu_firewall" {
  name                = "${var.eu_networking_core_location}-fw"
  location            = var.eu_networking_core_location
  resource_group_name = azurerm_resource_group.eunetwork.name
  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.eu_AzureFirewallSubnet.id
    public_ip_address_id = azurerm_public_ip.eu_firewall_public_ip.id
  }
  sku_name           = "AZFW_VNet"
  sku_tier           = var.firewallandpolicysku
  firewall_policy_id = azurerm_firewall_policy.eu-azfw_premium_policy.id # <---This can be variable of existing policy
  # zones = [ "1", "2" ]  # <---Depending upon your requirement

  depends_on = [
    azurerm_subnet.eu_AzureFirewallSubnet,
    azurerm_public_ip.eu_firewall_public_ip,
    azurerm_firewall_policy.eu-azfw_premium_policy
  ]

  tags = local.common_tags

}

# EU Firewall Public IP resource
resource "azurerm_public_ip" "eu_firewall_public_ip" {
  name                = "${var.eu_networking_core_location}-fw-pip"
  location            = var.eu_networking_core_location
  resource_group_name = azurerm_resource_group.eunetwork.name
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = local.common_tags

}