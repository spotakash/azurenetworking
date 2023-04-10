variable "address_space" {
  type    = string
  default = "172.16"
}

variable "asia_networking_resource_group" {
  type    = string
  default = "asia_networking"
}

# variable "asia_networking_core_location" {
#   type    = string
#   default = "eastasia"
# }

variable "eu_networking_resource_group" {
  type    = string
  default = "eu_networking"
}

# variable "eu_networking_core_location" {
#   type    = string
#   default = "westeurope"
# }

# Spoke VNET Variables

variable "primary_location_asia" {
  type    = string
  default = "eastasia"
}

variable "branch1pubip" {
  type    = list(string)
  default = "192.168.2.1"
}

variable "vnet1_subnets_asia" {
  type = map(object({
    name                    = string
    subnet_address_prefixes = list(string)
  }))
  description = "A map to create multiple subnets"
}

variable "primary_location_eu" {
  type    = string
  default = "westeurope"
}

# variable "vnet1_address_space_eu" {
#   type = list(string)
#   default = [""]
#   description = "value of the address space of EU Spoke VNET1"
# }

variable "vnet1_subnets_eu" {
  type = map(object({
    name                    = string
    subnet_address_prefixes = list(string)
  }))
  description = "A map to create multiple subnets"
}