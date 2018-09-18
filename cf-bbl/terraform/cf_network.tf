variable "cf_internal_cidr" {
  default = "10.0.16.0/20"
}

resource "azurerm_subnet" "cf-subnet" {
  name                 = "${var.env_id}-cf-sn"
  resource_group_name = "${data.azurerm_resource_group.bosh.name}"
  depends_on           = ["azurerm_virtual_network.bosh"]
  virtual_network_name = "${azurerm_virtual_network.bosh.name}"
  address_prefix       = "${cidrsubnet(var.network_cidr, 4, 1)}" //network_cidr = 10.0.0.0/16 => 10.0.16.0/20
}

// Security Group For CFCR
resource "azurerm_network_security_group" "cf" {
  name                = "${var.env_id}-cf-sg"
  location            = "${var.region}"
  resource_group_name = "${data.azurerm_resource_group.bosh.name}"

  security_rule {
    name                       = "cf-https"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "cf-log"
    priority                   = 102
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "4443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "cf-http"
    priority                   = 103
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "cf-ssh"
    priority                   = 104
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "2222"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

output "cf_subnet" {
  value = "${azurerm_subnet.cf-subnet.name}"
}

output "cf_subnet_cidr" {
  value = "${cidrsubnet(var.network_cidr, 4, 1)}"
}

output "cf_internal_gw" {
  value = "${cidrhost(var.cf_internal_cidr, 1)}"
}

output "system_domain" {
  value = "${azurerm_public_ip.cf-balancer-ip.ip_address}.xip.io"
}

output "cf_security_group" {
  value= "${azurerm_network_security_group.cf.name}"
}