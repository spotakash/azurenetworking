address_space                = "172.16"
sg_networking_resource_group = "sg_networking"
sg_networking_core_location  = "eastasia"
we_networking_resource_group = "we_networking"
we_networking_core_location  = "westeurope"
sg_spoke_vnet = {
  sg_spoke1 = {
    name     = "aks-vnet-21372380"
    vnet_id  = "/subscriptions/7b272202-731b-4b85-9827-91724edb94ac/resourceGroups/MC_ctsimulation_ctaks_eastasia/providers/Microsoft.Network/virtualNetworks/aks-vnet-21372380"
    spoke_rg = "MC_ctsimulation_ctaks_eastasia"
  }
  sg_spoke2 = {
    name     = "Central_Vnet"
    vnet_id  = "/subscriptions/7b272202-731b-4b85-9827-91724edb94ac/resourceGroups/Do_Not_Delete/providers/Microsoft.Network/virtualNetworks/Central_Vnet"
    spoke_rg = "Do_Not_Delete"
  }
}
we_spoke_vnet = {
  we_spoke1 = {
    name     = "VNET-AVD"
    vnet_id  = "/subscriptions/7b272202-731b-4b85-9827-91724edb94ac/resourceGroups/GDB/providers/Microsoft.Network/virtualNetworks/VNET-AVD"
    spoke_rg = "GDB"
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
