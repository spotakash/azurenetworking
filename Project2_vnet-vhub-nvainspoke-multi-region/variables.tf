variable "projectname" {
  type    = string
  default = "Project2"
}

variable "vmsize" {
  type    = string
  default = "Standard_B1s"
}

variable "vmadmin_username" {
  type    = string
  default = "username"
}
variable "vmpassword" {
  type    = string
  default = "complexpassword"
}

variable "myip" {
  type    = string
  default = "192.168.0.0"

}

variable "officeip" {
  type    = string
  default = "192.168.2.0"
}

variable "address_space" {
  type    = string
  default = "172.16"
}

variable "branch_space" {
  type    = string
  default = "198.168"
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

variable "westus_networking_core_location" {
  type    = string
  default = "westus_networking"
}

variable "firewallandpolicysku" {
  type    = string
  default = "Premium"
}