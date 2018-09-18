
output "storage_account_key" {
  value="${azurerm_storage_account.bosh.primary_access_key}"
}