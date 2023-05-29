core_location = "eastasia"
projectname   = "routingintent"
firewall_sku  = "Premium"
vhub_ip_groups = {
  "NCU-HUB" = {
    name     = "NCU-HUB"
    cidrs    = ["172.16.2.0/23"]
    location = "northcentralus"
    # avoid adding more CIDR for HUB as it can only have 1 CIDR
  }
  "WCU-HUB" = {
    name     = "WCU-HUB"
    cidrs    = ["172.16.0.0/23"]
    location = "westcentralus"
    # avoid adding more CIDR for HUB as it can only have 1 CIDR
  }
}

spoke_vnets_ip_groups = {
  "NCU-HUB" = {
    name     = "NCU-SPOKE-1"
    cidrs    = ["172.16.8.0/24"]
    location = "northcentralus"
  }
  "WCU-HUB" = {
    name     = "WCU-SPOKE-1"
    cidrs    = ["172.16.4.0/24"]
    location = "westcentralus"
  }
}

spoke_subnets = {
  "NCU-HUB" = {
    name  = "NCU-SPOKE-1-Subnet-1"
    cidrs = ["172.16.8.0/24"]
  }
  "WCU-HUB" = {
    name  = "WCU-SPOKE-1-Subnet-1"
    cidrs = ["172.16.4.0/25"]
  }
}