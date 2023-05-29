resource "azurerm_resource_group" "ipgroups" {
  name     = "${var.projectname}-ipgroups"
  location = var.core_location

  tags = local.common_tags
}

resource "azurerm_ip_group" "vhub" {
  for_each            = var.vhub_ip_groups
  name                = each.value["name"]
  resource_group_name = azurerm_resource_group.ipgroups.name
  location            = azurerm_resource_group.ipgroups.location
  cidrs               = each.value["cidrs"]

}

resource "azurerm_ip_group" "spoke_vnets" {
  for_each            = var.spoke_vnets_ip_groups
  name                = each.value["name"]
  resource_group_name = azurerm_resource_group.ipgroups.name
  location            = azurerm_resource_group.ipgroups.location
  cidrs               = each.value["cidrs"]

}

resource "azurerm_ip_group" "myips" {
  name                = "myips"
  resource_group_name = azurerm_resource_group.ipgroups.name
  location            = azurerm_resource_group.ipgroups.location
  cidrs               = var.myips

}

# We are not using this code, but it is here for reference
# Local variables to join the IP Group IDs
# locals {
#   joined_spoke_vnets_ids = {
#     for key in keys(var.spoke_vnets_ip_groups) : key => join(",", [azurerm_ip_group.spoke_vnets[key].id])
#   }
# }

# # Local variables to join the IP Group IDs
# locals {
#   joined_vhub_vnets_ids = {
#     for key in keys(var.vhub_ip_groups) : key => join(",", [azurerm_ip_group.vhub[key].id])
#   }
# }