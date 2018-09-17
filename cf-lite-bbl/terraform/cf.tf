resource "azurerm_subnet" "cf-subnet" {
  name                 = "${var.env_id}-cf-sn"
  resource_group_name  = "${azurerm_resource_group.rg.name}"
  depends_on           = ["azurerm_virtual_network.vnet"]
  virtual_network_name = "${azurerm_virtual_network.vnet.name}"
  address_prefix       = "${cidrsubnet(var.network_cidr, 4, 1)}" //network_cidr = 10.0.0.0/16 => 10.0.16.0/20
}