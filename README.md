## How to Deploy BOSH
cd into the cf or cf-lite folder, and then run
```
terraform apply -var prefix="YOUR PREFIX FOR RESOURCE" -var subscription_id="YOUR SUBSCRIPTION ID" -var client_id="YOUR SERVICE PRINCIPAL ID" -var client_secret="YOUR SERVICE PRINCIPAL PASSWORD" -var tenant_id="YOUR TENANT ID" -var ssh_user_username="cfuser" -var ssh_public_key_filename="./ssh_key.pub" -var auto_deploy_bosh="enabled" -var debug_mode="disabled" -var auto_deploy_cf="disabled"
```

## How to Deploy CF/CF-Lite
cd into the cf or cf-lite folder, and then run
```
terraform apply -var prefix="YOUR PREFIX FOR RESOURCES" -var subscription_id="YOUR SUBSCRIPTION ID" -var client_id="YOUR SERVICE PRINCIPAL ID" -var client_secret="YOUR SERVICE PRINCIPAL PASSWORD" -var tenant_id="YOUR TENANT ID" -var ssh_user_username="cfuser" -var ssh_public_key_filename="./ssh_key.pub" -var auto_deploy_bosh="enabled" -var -var auto_deploy_cf="enabled"
```
