variable "cfcr_internal_cidr" {
  default = "10.0.16.0/20"
}
// Subnet for CFCR
resource "azurerm_subnet" "cfcr-subnet" {
  name                 = "${var.env_id}-cfcr-sn"
  resource_group_name  = "${data.azurerm_resource_group.bosh.name}"
  virtual_network_name = "${azurerm_virtual_network.bosh.name}"
  address_prefix       = "${cidrsubnet(var.network_cidr, 4, 1)}"
  network_security_group_id = "${azurerm_network_security_group.cfcr-master.id}"
}

// Security Group For CFCR
resource "azurerm_network_security_group" "cfcr-master" {
  name                = "${var.env_id}-cfcr-master-sg"
  location            = "${var.region}"
  resource_group_name          = "${data.azurerm_resource_group.bosh.name}"

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

output "cfcr_subnet" {
  value = "${azurerm_subnet.cfcr-subnet.name}"
}

output "cfcr_subnet_cidr" {
  value = "${cidrsubnet(var.network_cidr, 4, 1)}"
}

output "cfcr_internal_gw" {
  value = "${cidrhost(var.cfcr_internal_cidr, 1)}"
}

output "master_security_group" {
  value = "${azurerm_network_security_group.cfcr-master.name}"
}