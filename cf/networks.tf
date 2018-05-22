// Subnet for BOSH
resource "azurerm_virtual_network" "vnet" {
  name                = "${module.variables.vnet-name}"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  depends_on          = ["azurerm_resource_group.rg"]
  address_space       = ["${var.network_cidr}"]
  dns_servers         = ["168.63.129.16"]
}

resource "azurerm_subnet" "bosh-subnet" {
  name                 = "${module.variables.bosh-subnet-name}"
  resource_group_name  = "${azurerm_resource_group.rg.name}"
  depends_on           = ["azurerm_virtual_network.vnet"]
  virtual_network_name = "${azurerm_virtual_network.vnet.name}"
  address_prefix       = "${cidrsubnet(var.network_cidr, 8, 0)}" //network_cidr = 10.0.0.0/16
}

resource "azurerm_subnet" "cf-subnet" {
  name                 = "${module.variables.cf-subnet-name}"
  resource_group_name  = "${azurerm_resource_group.rg.name}"
  depends_on           = ["azurerm_virtual_network.vnet"]
  virtual_network_name = "${azurerm_virtual_network.vnet.name}"
  address_prefix       = "${cidrsubnet(var.network_cidr, 4, 1)}" //network_cidr = 10.0.0.0/16 => 10.0.16.0/20
}
