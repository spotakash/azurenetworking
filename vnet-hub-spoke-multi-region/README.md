# Multi Region Virtual Networking (Traditional) HUB-SPOKE with VNET Peering  

### Very Important: It is just an asset with no liability or accountability. Use it at your own risk. 
### It was tested working in lab environment, please validate code and test it in your environment before using it in production. 

This code base helps you to quickly build Traditional Virtual Network HUB SPOKE Topology with VNET Peering. 
If you have existing **SPOKE VNET**, this Code base will help you to build HUB VNET and VNET Peering between HUB and SPOKE VNET, by simply providing the SPOKE VNET details in TFVAR.

Key Componet, it will help build and achieve;
- HUB VNET across two Azure Region
- Each HUB VNET will have Standard CIDR Definition to minimize work and standard Subnets precreated
- Each HUB VNET will be peered with other HUB VNET (Multi Region)
- Placeholder Map Variable to add SPOKE VNET resourceId to be peered with HUB VNET
- Each HUB VNET and SPOKE VNET will be peered to their respective Region HUB VNET
- Each HUB VNET will have ER Gateway Provision with Standard configuration
- Each Peering (HUB to HUB and HUB to SPOKE (vice versa)) will have Standard configuration for Peering around `allow_gateway_transit` and `use_remote_gateways`
- Each HUB VNET will have `AzureFirewall` deployed with `Premium` SKU, using Common `AzureFirewallPolicy` of `Premium` SKU

## Prerequisites
- This code is using Single Azure Subscription to build HUB and SPOKE VNET
- To be build similar configuration across multi-Subscription you should use Terraform `ALIAS` and `PROVIDER` to build the same configuration