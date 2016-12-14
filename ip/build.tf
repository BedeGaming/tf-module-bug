variable "location" {}
variable "name" {}
variable "resourceGroupName" {}
variable "publicIpAddressAllocation" {
  default = "dynamic"
}
variable "idleTimeoutInMinutes" {
  default = "4"
}
variable "reverseFqdn" {
  default = false
}
variable "tags" {
  type = "map"
  default = {}
}

resource "azurerm_public_ip" "publicIp" {
  name                         = "${var.name}"
  location                     = "${var.location}"
  resource_group_name          = "${var.resourceGroupName}"
  public_ip_address_allocation = "${var.publicIpAddressAllocation}"
}

output "id" {
  value = "${azurerm_public_ip.publicIp.id}"
}

output "ipAddress" {
  value = "${azurerm_public_ip.publicIp.ip_address}"
}

output "fqdn" {
  value = "${azurerm_public_ip.publicIp.fqdn}"
}