resource "azurerm_public_ip" "cf-balancer-ip" {
  name                         = "${module.namings.cf-balancer-public-ip-name}"
  location                     = "${var.location}"
  resource_group_name          = "${azurerm_resource_group.rg.name}"
  depends_on                   = ["azurerm_resource_group.rg"]
  public_ip_address_allocation = "static"
  sku                          = "Standard"
}

resource "azurerm_lb" "cf-balancer" {
  name                = "${module.namings.cf-balancer-name}"
  location            = "${var.location}"
  sku                 = "Standard"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  depends_on          = ["azurerm_public_ip.cf-balancer-ip"]

  frontend_ip_configuration {
    name                 = "${azurerm_public_ip.cf-balancer-ip.name}"
    public_ip_address_id = "${azurerm_public_ip.cf-balancer-ip.id}"
  }
}

resource "azurerm_lb_backend_address_pool" "cf-balancer-backend-pool" {
  name                = "${var.prefix}-cf-backend-pool"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  depends_on          = ["azurerm_lb.cf-balancer"]
  loadbalancer_id     = "${azurerm_lb.cf-balancer.id}"
}

resource "azurerm_lb_probe" "health-probe" {
  name                = "${var.prefix}-health-probe"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  depends_on          = ["azurerm_lb.cf-balancer"]
  loadbalancer_id     = "${azurerm_lb.cf-balancer.id}"
  protocol            = "HTTP"
  request_path        = "/health"
  interval_in_seconds = 5
  number_of_probes    = 2
  port                = 8080
}

resource "azurerm_lb_rule" "cf-balancer-rule-https" {
  name                           = "${var.prefix}-https-rule"
  resource_group_name            = "${azurerm_resource_group.rg.name}"
  depends_on                     = ["azurerm_lb_probe.health-probe", "azurerm_lb_backend_address_pool.cf-balancer-backend-pool"]
  loadbalancer_id                = "${azurerm_lb.cf-balancer.id}"
  protocol                       = "Tcp"
  frontend_port                  = 443
  backend_port                   = 443
  frontend_ip_configuration_name = "${azurerm_public_ip.cf-balancer-ip.name}"
  probe_id                       = "${azurerm_lb_probe.health-probe.id}"
  backend_address_pool_id        = "${azurerm_lb_backend_address_pool.cf-balancer-backend-pool.id}"
}

resource "azurerm_lb_rule" "cf-balancer-rule-http" {
  name                           = "${var.prefix}-http-rule"
  resource_group_name            = "${azurerm_resource_group.rg.name}"
  depends_on                     = ["azurerm_lb_probe.health-probe", "azurerm_lb_backend_address_pool.cf-balancer-backend-pool"]
  loadbalancer_id                = "${azurerm_lb.cf-balancer.id}"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "${azurerm_public_ip.cf-balancer-ip.name}"
  probe_id                       = "${azurerm_lb_probe.health-probe.id}"
  backend_address_pool_id        = "${azurerm_lb_backend_address_pool.cf-balancer-backend-pool.id}"
}
