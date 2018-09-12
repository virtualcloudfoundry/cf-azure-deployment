// Security Group For CFCR
resource "azurerm_network_security_group" "cfcr-master" {
  name                = "${module.variables.cfcr-master-sg-name}"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  depends_on          = ["azurerm_resource_group.rg"]

  security_rule {
    name                       = "master"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}
