
output "default_storage_account_name" {
  value="${azurerm_storage_account.bosh.name}"
}
output "default_storage_account_key" {
  value="${azurerm_storage_account.bosh.primary_access_key}"
}