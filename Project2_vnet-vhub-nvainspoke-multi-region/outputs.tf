# output "subnet_id" {
#   value = [for subnet in azurerm_subnet.vnetprefix : subnet.id]
# }

data "azurerm_firewall" "asia_firewall_public_ip" {
  name                = azurerm_firewall.asia_firewall.name
  resource_group_name = azurerm_resource_group.asianetwork.name
}

output "asia_firewall_public_ip" {
  value = data.azurerm_firewall.asia_firewall_public_ip.virtual_hub[0].public_ip_addresses
}


data "azurerm_firewall" "eu_firewall_public_ip" {
  name                = azurerm_firewall.eu_firewall.name
  resource_group_name = azurerm_resource_group.eunetwork.name
}

output "eu_firewall_public_ip" {
  value = data.azurerm_firewall.eu_firewall_public_ip.virtual_hub[0].public_ip_addresses
}