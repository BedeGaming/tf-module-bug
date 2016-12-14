variable "location" {
    default = "North Europe"
}

module "rg" {
  source   = "./rg"
  location = "${var.location}"
  name     = "test-module-rg"
}

module "ip" {
  source                    = "./ip"
  location                  = "${var.location}"
  name                      = "test-module-ip"
  resourceGroupName         = "${module.rg.name}"
  publicIpAddressAllocation = "static"
}

module "lb" {
  source                      = "./lb"
  location                    = "${var.location}"
  name                        = "test-module-lb"
  resourceGroupName           = "${module.rg.name}"
  frontendIpConfigurationName = "module-test-lb-fip"
  publicIpId                  = "${module.ip.id}"
  backendAddressPoolName      = "module-test-lb-bap"
}