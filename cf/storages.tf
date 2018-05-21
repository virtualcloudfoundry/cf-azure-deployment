resource "azurerm_storage_account" "bosh-default-storage" {
  name                     = "boshdefaultsa"
  resource_group_name      = "${azurerm_resource_group.rg.name}"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  location                 = "${var.location}"

  tags {
    environment = "${module.variables.environment-tag}"
  }
}

resource "azurerm_storage_account" "aci-default-storage" {
  count                    = "${var.use_vcontainer=="enabled"?1:0}"
  name                     = "acidefaultsa"
  resource_group_name      = "${azurerm_resource_group.rg.name}"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  location                 = "${var.location}"

  tags {
    environment = "${module.variables.environment-tag}"
  }
}
