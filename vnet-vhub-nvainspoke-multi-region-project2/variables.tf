variable "address_space" {
  type    = string
  default = "172.16"
}

variable "asia_networking_resource_group" {
  type    = string
  default = "asia_networking"
}

variable "asia_networking_core_location" {
  type    = string
  default = "eastasia"
}

variable "eu_networking_resource_group" {
  type    = string
  default = "eu_networking"
}

variable "eu_networking_core_location" {
  type    = string
  default = "westeurope"
}

# variable "asia_spoke_vnet" {
#   type = map(object({
#     name     = string
#     vnet_id  = string
#     spoke_rg = string
#   }))
#   description = "Asia spoke resource ID"
# }

# variable "eu_spoke_vnet" {
#   type = map(object({
#     name     = string
#     vnet_id  = string
#     spoke_rg = string
#   }))
#   description = "EU spoke resource ID"
# }