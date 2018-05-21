## How to Deploy BOSH
terraform apply -var prefix="<YOUR PREFIX FOR RESOURCES>" -var subscription_id="<YOUR SUBSCRIPTION ID>" -var client_id="<YOUR SERVICE PRINCIPAL ID>" -var client_secret="<YOUR SERVICE PRINCIPAL PASSWORD>" -var tenant_id="<YOUR TENANT ID>" -var ssh_user_username="cfuser" -var ssh_public_key_filename="./ssh_key.pub" -var auto_deploy_bosh="enabled" -var debug_mode="disabled" -var auto_deploy_cf="disabled"

## How to Deploy CF
terraform apply -var prefix="<YOUR PREFIX FOR RESOURCES>" -var subscription_id="<YOUR SUBSCRIPTION ID>" -var client_id="<YOUR SERVICE PRINCIPAL ID>" -var client_secret="<YOUR SERVICE PRINCIPAL PASSWORD>" -var tenant_id="<YOUR TENANT ID>" -var ssh_user_username="cfuser" -var ssh_public_key_filename="./ssh_key.pub" -var auto_deploy_bosh="enabled" -var debug_mode="disabled" -var auto_deploy_cf="enabled"
