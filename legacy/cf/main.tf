provider "azurerm" {
  subscription_id = "${var.subscription_id}"
  tenant_id       = "${var.tenant_id}"
  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
}

module "namings" {
  source = "../common_tf/namings"
  prefix = "${var.prefix}"
}

module "it" {
  source       = "../common_tf/it"
  prefix       = "${var.prefix}"
  location     = "${var.location}"
  network_cidr = "${var.network_cidr}"
}
