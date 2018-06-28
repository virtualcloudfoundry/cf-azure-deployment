// Subnet for BOSH
resource "azurerm_virtual_network" "vnet" {
  name                = "${module.namings.vnet-name}"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  depends_on          = ["azurerm_resource_group.rg"]
  address_space       = ["${var.network_cidr}"]

  # dns_servers         = ["168.63.129.16"]
}

resource "azurerm_subnet" "bosh-subnet" {
  name                 = "${module.namings.bosh-subnet-name}"
  resource_group_name  = "${azurerm_resource_group.rg.name}"
  depends_on           = ["azurerm_virtual_network.vnet"]
  virtual_network_name = "${azurerm_virtual_network.vnet.name}"
  address_prefix       = "${cidrsubnet(var.network_cidr, 8, 0)}" //network_cidr = 10.0.0.0/16
}

resource "azurerm_subnet" "cf-subnet" {
  name                 = "${module.namings.cf-subnet-name}"
  resource_group_name  = "${azurerm_resource_group.rg.name}"
  depends_on           = ["azurerm_virtual_network.vnet"]
  virtual_network_name = "${azurerm_virtual_network.vnet.name}"
  address_prefix       = "${cidrsubnet(var.network_cidr, 4, 1)}" //network_cidr = 10.0.0.0/16 => 10.0.16.0/20
}

resource "azurerm_public_ip" "bastion" {
  name                         = "${module.namings.bastion-ip-name}"
  location                     = "${var.location}"
  depends_on                   = ["azurerm_resource_group.rg"]
  resource_group_name          = "${module.namings.resource-group-name}"
  public_ip_address_allocation = "static"
  sku                          = "Standard"

  tags {
    environment = "${module.namings.environment-tag}"
  }
}

// BOSH bastion host
resource "azurerm_network_interface" "bastion" {
  name                      = "${module.namings.bastion-nic-name}"
  depends_on                = ["azurerm_public_ip.bastion", "azurerm_subnet.bosh-subnet", "azurerm_network_security_group.bastion"]
  location                  = "${var.location}"
  resource_group_name       = "${azurerm_resource_group.rg.name}"
  network_security_group_id = "${azurerm_network_security_group.bastion.id}"

  ip_configuration {
    name                          = "${var.prefix}-bastion-ip-config"
    subnet_id                     = "${azurerm_subnet.bosh-subnet.id}"
    private_ip_address_allocation = "static"
    private_ip_address            = "${cidrhost(azurerm_subnet.bosh-subnet.address_prefix,100)}"
    public_ip_address_id          = "${azurerm_public_ip.bastion.id}"
  }
}
