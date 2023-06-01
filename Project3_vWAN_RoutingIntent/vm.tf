# Resource Group VM
resource "azurerm_resource_group" "vm" {
  name     = "${var.projectname}-vm"
  location = var.core_location

  tags = local.common_tags
}

# VM in each spoke
resource "azurerm_virtual_machine" "vm" {
  for_each                         = var.spoke_vnets_ip_groups
  name                             = "${each.value["name"]}-vm"
  resource_group_name              = azurerm_resource_group.vm.name
  location                         = each.value["location"]
  network_interface_ids            = [azurerm_network_interface.vm[each.key].id]
  vm_size                          = "Standard_B1s"
  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true
  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }
  storage_os_disk {
    name              = "${each.value["name"]}-vm-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "${each.value["name"]}-vm"
    admin_username = "username"
    admin_password = "complexpassword"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags = local.common_tags

  depends_on = [
    azurerm_network_interface.vm,
    azurerm_network_security_group.nsg,
  ]
}

# VM NIC 
resource "azurerm_network_interface" "vm" {
  for_each            = var.spoke_vnets_ip_groups
  name                = "${each.value["name"]}-vm-nic"
  resource_group_name = azurerm_resource_group.vm.name
  location            = each.value["location"]
  ip_configuration {
    name                          = "${each.value["name"]}-vm-ipconfig"
    subnet_id                     = azurerm_subnet.spoke_subnets[each.key].id
    private_ip_address_allocation = "Dynamic"
  }

  tags = local.common_tags
  depends_on = [
    azurerm_ip_group.spoke_vnets
  ]
}

# NSG for VM 
resource "azurerm_network_security_group" "nsg" {
  for_each            = var.spoke_vnets_ip_groups
  name                = "${each.value["name"]}-vm-nsg"
  location            = each.value["location"]
  resource_group_name = azurerm_resource_group.vm.name

  security_rule {
    name                       = "Allow-SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

}

# NSG Association
resource "azurerm_network_interface_security_group_association" "nsg_association" {
  for_each                  = var.spoke_vnets_ip_groups
  network_interface_id      = azurerm_network_interface.vm[each.key].id
  network_security_group_id = azurerm_network_security_group.nsg[each.key].id

  depends_on = [
    azurerm_network_interface.vm,
    azurerm_network_security_group.nsg
  ]
}
