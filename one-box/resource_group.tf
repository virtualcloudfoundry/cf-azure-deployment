resource "azurerm_resource_group" "rg" {
  name     = "${module.variables.resource-group-name}"
  location = "${var.location}"

  tags {
    environment = "${module.variables.environment-tag}"
  }
}
