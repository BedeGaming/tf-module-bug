# TF Module Bug

Terraform apears to destroy resources in the wrong order.

## Steps to reproduce

With repo cloned and Azure credentials setup:

```bash
terraform get
terraform apply
terraform destroy
```

The apply should be successful with resources created in the correct order, sequentially:

* resource group (mod.rg)
* public ip (mod.ip)
* load balancer (mod.lb)

The destroy operation fails with an error, the output below indicates that the
deletion of several resources was kicked off concurrently, when they should actually
be deleted in sequence. The error thrown is due to the public ip being deleted when
it is still in use.

```
Do you really want to destroy?
  Terraform will delete all your managed infrastructure.
  There is no undo. Only 'yes' will be accepted to confirm.

  Enter a value: yes

module.rg.azurerm_resource_group.resourceGroup: Refreshing state... (ID: /subscriptions/000000/resourceGroups/test-module-rg)
module.ip.azurerm_public_ip.publicIp: Refreshing state... (ID: /subscriptions/000000/resourceGroups/test-module-rg/providers/Microsoft.Network/publicIPAddresses/test-module-ip)
module.lb.azurerm_lb.loadBalancer: Refreshing state... (ID: /subscriptions/000000/resourceGroups/test-module-rg/providers/Microsoft.Network/loadBalancers/test-module-lb)
module.lb.azurerm_lb_backend_address_pool.backendAddressPool: Refreshing state... (ID: /subscriptions/000000/resourceGroups/test-module-rg/providers/Microsoft.Network/loadBalancers/test-module-lb/backendAddressPools/module-test-lb-bap)
module.ip.azurerm_public_ip.publicIp: Destroying...
module.rg.azurerm_resource_group.resourceGroup: Destroying...
module.lb.azurerm_lb_backend_address_pool.backendAddressPool: Destroying...
module.lb.azurerm_lb_backend_address_pool.backendAddressPool: Destruction complete
module.lb.azurerm_lb.loadBalancer: Destroying...
module.rg.azurerm_resource_group.resourceGroup: Still destroying... (10s elapsed)
module.lb.azurerm_lb.loadBalancer: Still destroying... (10s elapsed)
module.rg.azurerm_resource_group.resourceGroup: Still destroying... (20s elapsed)
module.lb.azurerm_lb.loadBalancer: Still destroying... (20s elapsed)
module.lb.azurerm_lb.loadBalancer: Destruction complete
module.rg.azurerm_resource_group.resourceGroup: Still destroying... (30s elapsed)
module.rg.azurerm_resource_group.resourceGroup: Still destroying... (40s elapsed)
module.rg.azurerm_resource_group.resourceGroup: Still destroying... (50s elapsed)
module.rg.azurerm_resource_group.resourceGroup: Still destroying... (1m0s elapsed)
module.rg.azurerm_resource_group.resourceGroup: Still destroying... (1m10s elapsed)
module.rg.azurerm_resource_group.resourceGroup: Still destroying... (1m20s elapsed)
module.rg.azurerm_resource_group.resourceGroup: Still destroying... (1m30s elapsed)
module.rg.azurerm_resource_group.resourceGroup: Destruction complete
Error applying plan:

1 error(s) occurred:

* azurerm_public_ip.publicIp: network.PublicIPAddressesClient#Delete: Failure responding to request: StatusCode=400 -- Original Error: autorest/azure: Service returned an error. Status=400 Code="PublicIPAddressCannotBeDeleted" Message="Public IP address /subscriptions/000000/resourceGroups/test-module-rg/providers/Microsoft.Network/publicIPAddresses/test-module-ip can not be deleted since it is still allocated to resource /subscriptions/000000/resourceGroups/test-module-rg/providers/Microsoft.Network/loadBalancers/test-module-lb." Details=[]
```
