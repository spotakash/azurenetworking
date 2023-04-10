address_space                  = "172.16"
asia_networking_resource_group = "asia_networking"
# asia_networking_core_location  = "eastasia"
eu_networking_resource_group = "eu_networking"
# eu_networking_core_location    = "westeurope"
primary_location_asia = "eastasia"
primary_location_eu   = "westeurope"

vnet1_subnets_asia = {
  subnet1 = {
    subnet_address_prefixes = ["172.16.7.0/26"]
    name                    = "web-subnet"
  }
  subnet2 = {
    subnet_address_prefixes = ["172.16.7.64/26"]
    name                    = "db-subnet"
  }
  subnet3 = {
    subnet_address_prefixes = ["172.16.7.128/26"]
    name                    = "app-subnet"
  }
  subnet4 = {
    subnet_address_prefixes = ["172.16.7.192/26"]
    name                    = "AzureBastionSubnet"
  }
}

branch1pubip = "34.124.43.67"
branch1sharedkey = "JNB22OUrv2Lq7xzx+1SKeUAkqcZA3rl4"
vnet1_subnets_eu = {
  subnet1 = {
    subnet_address_prefixes = ["172.16.5.0/26"]
    name                    = "web-subnet"
  }
  subnet2 = {
    subnet_address_prefixes = ["172.16.5.64/26"]
    name                    = "db-subnet"
  }
  subnet3 = {
    subnet_address_prefixes = ["172.16.5.128/26"]
    name                    = "app-subnet"
  }
  subnet4 = {
    subnet_address_prefixes = ["172.16.5.192/26"]
    name                    = "SpareSubnet"
  }
}