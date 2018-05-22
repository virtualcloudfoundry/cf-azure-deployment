resource "azurerm_public_ip" "cf-balancer-ip" {
  name                         = "${var.prefix}-cf-public-ip"
  location                     = "${var.location}"
  resource_group_name          = "${azurerm_resource_group.rg.name}"
  public_ip_address_allocation = "static"
  sku                          = "Standard"
}

resource "azurerm_lb" "cf-balancer" {
  name                = "${var.prefix}-cf-balancer"
  location            = "${var.location}"
  sku                 = "Standard"
  resource_group_name = "${azurerm_resource_group.rg.name}"

  frontend_ip_configuration {
    name                 = "${azurerm_public_ip.cf-balancer-ip.name}"
    public_ip_address_id = "${azurerm_public_ip.cf-balancer-ip.id}"
  }
}

resource "azurerm_lb_backend_address_pool" "cf-balancer-backend-pool" {
  name                = "${var.prefix}-cf-backend-pool"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  loadbalancer_id     = "${azurerm_lb.cf-balancer.id}"
}

resource "azurerm_lb_probe" "web-https-probe" {
  name                = "${var.prefix}-web-https-probe"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  loadbalancer_id     = "${azurerm_lb.cf-balancer.id}"
  protocol            = "TCP"
  port                = 443
}

resource "azurerm_lb_probe" "web-http-probe" {
  name                = "${var.prefix}-web-http-probe"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  loadbalancer_id     = "${azurerm_lb.cf-balancer.id}"
  protocol            = "TCP"
  port                = 80
}

resource "azurerm_lb_rule" "cf-balancer-rule-https" {
  resource_group_name            = "${azurerm_resource_group.rg.name}"
  loadbalancer_id                = "${azurerm_lb.cf-balancer.id}"
  name                           = "${var.prefix}-https-rule"
  protocol                       = "Tcp"
  frontend_port                  = 443
  backend_port                   = 443
  frontend_ip_configuration_name = "${azurerm_public_ip.cf-balancer-ip.name}"
  probe_id                       = "${azurerm_lb_probe.web-https-probe.id}"
}

resource "azurerm_lb_rule" "cf-balancer-rule-http" {
  resource_group_name            = "${azurerm_resource_group.rg.name}"
  loadbalancer_id                = "${azurerm_lb.cf-balancer.id}"
  name                           = "${var.prefix}-http-rule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "${azurerm_public_ip.cf-balancer-ip.name}"
  probe_id                       = "${azurerm_lb_probe.web-http-probe.id}"
}
