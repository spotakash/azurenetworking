address_space                = "172.16"
sg_networking_resource_group = "sg_networking"
sg_networking_core_location  = "eastasia"
we_networking_resource_group = "we_networking"
we_networking_core_location  = "westeurope"
sg_spoke_vnet = {
  sg_spoke1 = {
    name     = "Name of SG SPOKE VNET 1"
    vnet_id  = "ResourceID of SG SPOKE VNET 1"
    spoke_rg = "Resource Group Name of SG SPOKE VNET 1"
  }
  sg_spoke2 = {
    name     = "Name of SG SPOKE VNET 2"
    vnet_id  = "ResourceID of SG SPOKE VNET 2"
    spoke_rg = "Resource Group Name of SG SPOKE VNET 2"
  }
}
we_spoke_vnet = {
  we_spoke1 = {
    name     = "Name of WE SPOKE VNET 1"
    vnet_id  = "ResourceID of WE SPOKE VNET 1"
    spoke_rg = "Resource Group Name of WE SPOKE VNET 1"
  }
  #   we_spoke2 = {
  #     name      = "we-spoke2"
  #     vnet_id = ""
  #   }
  #   we_spoke3 = {
  #     name      = "we-spoke3"
  #     vnet_id = ""
  #   }
}
