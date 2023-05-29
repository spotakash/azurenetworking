variable "projectname" {
  type    = string
  default = "Project2"
}

variable "core_location" {
  type    = string
  default = "eastus"
}

variable "firewall_sku" {
  type    = string
  default = "Premium"
}
variable "vhub_ip_groups" {
  type = map(object({
    name     = string
    cidrs    = list(string)
    location = string
  }))
  description = "A map to create ipgroups"
}

variable "spoke_vnets_ip_groups" {
  type = map(object({
    name     = string
    cidrs    = list(string)
    location = string
  }))
  description = "A map to create ipgroups for spoke vnets"
}

variable "spoke_subnets" {
  type = map(object({
    name  = string
    cidrs = list(string)
  }))
  description = "A map to create subnets for spoke vnets"
}

variable "myips" {
  type        = list(string)
  description = "A list of IP addresses to allow access to the firewall"
}