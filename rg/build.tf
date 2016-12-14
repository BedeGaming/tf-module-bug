variable "location" {}
variable "name" {}

resource "azurerm_resource_group" "resourceGroup" {
  name     = "${var.name}"
  location = "${var.location}"
}

output "name" {
  value = "${azurerm_resource_group.resourceGroup.name}"
}

output "id" {
  value = "${azurerm_resource_group.resourceGroup.id}"
}