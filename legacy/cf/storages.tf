resource "azurerm_storage_account" "aci-default-storage" {
  count                    = "${var.use_vcontainer=="enabled"?1:0}"
  name                     = "acidefaultsa"
  resource_group_name      = "${module.namings.resource-group-name}"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  location                 = "${var.location}"
  depends_on               = ["module.it"]

  tags {
    environment = "${module.namings.environment-tag}"
  }
}
