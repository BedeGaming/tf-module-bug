variable "location" {}
variable "name" {}
variable "resourceGroupName" {}
variable "frontendIpConfigurationName" {}
variable "publicIpId" {}
variable "backendAddressPoolName" {}

resource "azurerm_lb" "loadBalancer" {
  name                = "${var.name}"
  location            = "${var.location}"
  resource_group_name = "${var.resourceGroupName}"

  frontend_ip_configuration {
    name                 = "${var.frontendIpConfigurationName}"
    public_ip_address_id = "${var.publicIpId}"
  }
}

resource "azurerm_lb_backend_address_pool" "backendAddressPool" {
  name                = "${var.backendAddressPoolName}"
  location            = "${var.location}"
  resource_group_name = "${var.resourceGroupName}"
  loadbalancer_id     = "${azurerm_lb.loadBalancer.id}"
}

output "id" {
  value = "${azurerm_lb.loadBalancer.id}"
}
output "name" {
  value = "${azurerm_lb.loadBalancer.name}"
}

output "backendAddressPoolId" {
  value = "${azurerm_lb_backend_address_pool.backendAddressPool.id}"
}
output "backendAddressPoolName" {
  value = "${azurerm_lb_backend_address_pool.backendAddressPool.name}"
}