variable "cf_internal_cidr" {
  default = "10.0.16.0/20"
}

resource "azurerm_subnet" "cf-subnet" {
  name                 = "${var.env_id}-cf-sn"
  resource_group_name  = "${azurerm_resource_group.bosh.name}"
  depends_on           = ["azurerm_virtual_network.bosh"]
  virtssual_network_name = "${azurerm_virtual_network.bosh.name}"
  address_prefix       = "${cidrsubnet(var.network_cidr, 4, 1)}" //network_cidr = 10.0.0.0/16 => 10.0.16.0/20
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