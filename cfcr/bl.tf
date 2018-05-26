resource "azurerm_public_ip" "cfcr-balancer-ip" {
  name                         = "${var.prefix}-cfcr-public-ip"
  location                     = "${var.location}"
  resource_group_name          = "${azurerm_resource_group.rg.name}"
  depends_on                   = ["azurerm_resource_group.rg"]
  public_ip_address_allocation = "static"
  sku                          = "Standard"
}

resource "azurerm_lb" "cfcr-balancer" {
  name                = "${var.prefix}-cfcr-balancer"
  location            = "${var.location}"
  sku                 = "Standard"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  depends_on          = ["azurerm_public_ip.cfcr-balancer-ip"]

  frontend_ip_configuration {
    name                 = "${azurerm_public_ip.cfcr-balancer-ip.name}"
    public_ip_address_id = "${azurerm_public_ip.cfcr-balancer-ip.id}"
  }
}

resource "azurerm_lb_backend_address_pool" "cfcr-balancer-backend-pool" {
  name                = "${var.prefix}-cfcr-backend-pool"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  depends_on          = ["azurerm_lb.cfcr-balancer"]
  loadbalancer_id     = "${azurerm_lb.cfcr-balancer.id}"
}

resource "azurerm_lb_probe" "api-health-probe" {
  name                = "${var.prefix}-api-health-probe"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  depends_on          = ["azurerm_lb.cfcr-balancer"]
  loadbalancer_id     = "${azurerm_lb.cfcr-balancer.id}"
  protocol            = "Tcp"
  interval_in_seconds = 5
  number_of_probes    = 2
  port                = 8443
}

resource "azurerm_lb_rule" "cfcr-balancer-api-rule" {
  name                           = "${var.prefix}-api-rule"
  resource_group_name            = "${azurerm_resource_group.rg.name}"
  depends_on                     = ["azurerm_lb_probe.api-health-probe", "azurerm_lb_backend_address_pool.cfcr-balancer-backend-pool"]
  loadbalancer_id                = "${azurerm_lb.cfcr-balancer.id}"
  protocol                       = "Tcp"
  frontend_port                  = 8443
  backend_port                   = 8443
  frontend_ip_configuration_name = "${azurerm_public_ip.cfcr-balancer-ip.name}"
  probe_id                       = "${azurerm_lb_probe.api-health-probe.id}"
  backend_address_pool_id        = "${azurerm_lb_backend_address_pool.cfcr-balancer-backend-pool.id}"
}
