# # # output "bosh-subnet-name" {
# # #   value = "${var.prefix}-bosh-subnet"
# # # }
# output "rg_id" {
#   value = "${azurerm_resource_group.rg.id}"
# }

output "bastion-nic-id" {
  value = "${azurerm_network_interface.bastion.id}"
}

output "bosh-subnet-address-prefix" {
  value = "${azurerm_subnet.bosh-subnet.address_prefix}"
}

output "bosh-default-storage-primary-key" {
  value = "${azurerm_storage_account.bosh-default-storage.primary_access_key}"
}

output "cf-subnet-address-prefix" {
  value = "${azurerm_subnet.cf-subnet.address_prefix}"
}

output "cf-public-ip-address" {
  value = "${azurerm_public_ip.cf-balancer-ip.ip_address}"
}
