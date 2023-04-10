variable "address_space" {
  type    = string
  default = "192.168"
}

variable "sg_networking_resource_group" {
  type    = string
  default = "sg_networking"
}

variable "sg_networking_core_location" {
  type    = string
  default = "southeastasia"
}

variable "we_networking_resource_group" {
  type    = string
  default = "we_networking"
}

variable "we_networking_core_location" {
  type    = string
  default = "westeurope"
}

variable "sg_spoke_vnet" {
  type = map(object({
    name     = string
    vnet_id  = string
    spoke_rg = string
  }))
  description = "SG spoke resource ID"
}

variable "we_spoke_vnet" {
  type = map(object({
    name     = string
    vnet_id  = string
    spoke_rg = string
  }))
  description = "SG spoke resource ID"
}