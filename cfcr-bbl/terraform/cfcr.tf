// Subnet for CFCR
resource "azurerm_subnet" "cfcr-subnet" {
  name                 = "${var.env_id}-cfcr-sn"
  resource_group_name  = "${azurerm_resource_group.bosh.name}"
  virtual_network_name = "${azurerm_virtual_network.bosh.name}"
  address_prefix       = "${cidrsubnet(var.network_cidr, 4, 1)}"
  network_security_group_id = "${azurerm_network_security_group.cfcr-master.id}"
}

// Security Group For CFCR
resource "azurerm_network_security_group" "cfcr-master" {
  name                = "${var.env_id}-cfcr-master-sg"
  location            = "${var.region}"
  resource_group_name  = "${azurerm_resource_group.bosh.name}"

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

resource "azurerm_public_ip" "cfcr-balancer-ip" {
  name                         = "${var.env_id}-cfcr-public-ip"
  location                     = "${var.region}"
  resource_group_name  = "${azurerm_resource_group.bosh.name}"
  public_ip_address_allocation = "static"
  sku                          = "Standard"
}

resource "azurerm_lb" "cfcr-balancer" {
  name                = "${var.env_id}-cfcr-balancer"
  location            = "${var.region}"
  sku                 = "Standard"
  resource_group_name = "${azurerm_resource_group.bosh.name}"

  frontend_ip_configuration {
    name                 = "${azurerm_public_ip.cfcr-balancer-ip.name}"
    public_ip_address_id = "${azurerm_public_ip.cfcr-balancer-ip.id}"
  }
}

resource "azurerm_lb_backend_address_pool" "cfcr-balancer-backend-pool" {
  name                = "${var.env_id}-cfcr-backend-pool"
  resource_group_name = "${azurerm_resource_group.bosh.name}"
  loadbalancer_id     = "${azurerm_lb.cfcr-balancer.id}"
}

resource "azurerm_lb_probe" "api-health-probe" {
  name                = "${var.env_id}-api-health-probe"
  resource_group_name = "${azurerm_resource_group.bosh.name}"
  loadbalancer_id     = "${azurerm_lb.cfcr-balancer.id}"
  protocol            = "Tcp"
  interval_in_seconds = 5
  number_of_probes    = 2
  port                = 8443
}

resource "azurerm_lb_rule" "cfcr-balancer-api-rule" {
  name                           = "${var.env_id}-api-rule"
  resource_group_name            = "${azurerm_resource_group.bosh.name}"
  loadbalancer_id                = "${azurerm_lb.cfcr-balancer.id}"
  protocol                       = "Tcp"
  frontend_port                  = 8443
  backend_port                   = 8443
  frontend_ip_configuration_name = "${azurerm_public_ip.cfcr-balancer-ip.name}"
  probe_id                       = "${azurerm_lb_probe.api-health-probe.id}"
  backend_address_pool_id        = "${azurerm_lb_backend_address_pool.cfcr-balancer-backend-pool.id}"
}

