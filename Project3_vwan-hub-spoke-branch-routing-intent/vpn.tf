resource "azurerm_vpn_gateway" "asia_vpngw" {
  name                = "asia-vpngw"
  location            = var.primary_location_asia
  resource_group_name = azurerm_resource_group.vwan.name
  virtual_hub_id      = azurerm_virtual_hub.vhub-asia.id
}

resource "azurerm_vpn_site" "vpn1_asia_branch1" {
  name                = "vpn1_asia_gcp"
  resource_group_name = azurerm_resource_group.vwan.name
  location            = var.primary_location_asia
  virtual_wan_id      = azurerm_virtual_wan.wan.id
  address_cidrs       = ["10.0.0.0/24"]
  device_model        = "branch1-model"
  device_vendor       = "branch1-device"
  link {
    name          = "link1-branch1-sea"
    ip_address    = var.branch1pubip
    provider_name = "branch1-provider"
    speed_in_mbps = "100"
    bgp {
      asn             = "64512"
      peering_address = "169.254.46.134"
    }
  }
}

resource "azurerm_vpn_gateway_connection" "vpn1_asia_branch1" {
  name               = "asia-vhub-s2s-vpn1_asia_branch1"
  vpn_gateway_id     = azurerm_vpn_gateway.asia_vpngw.id
  remote_vpn_site_id = azurerm_vpn_site.vpn1_asia_branch1.id

  vpn_link {
    name             = "link1-branch1-sea"
    vpn_site_link_id = azurerm_vpn_site.vpn1_asia_branch1.link[0].id
    bgp_enabled      = true
    ipsec_policy {
      dh_group                 = "DHGroup14"
      ike_encryption_algorithm = "AES256"
      ike_integrity_algorithm  = "SHA256"
      encryption_algorithm     = "AES256"
      integrity_algorithm      = "SHA256"
      pfs_group                = "None"
      sa_data_size_kb          = "102400"
      sa_lifetime_sec          = "28800"
    }
    shared_key = var.branch1sharedkey
  }
  internet_security_enabled = true
  routing {
    associated_route_table_id = "${azurerm_virtual_hub.vhub-asia.id}/hubRouteTables/defaultRouteTable"
    propagated_route_table {
      route_table_ids = ["${azurerm_virtual_hub.vhub-asia.id}/hubRouteTables/noneRouteTable"]
    }
  }


}