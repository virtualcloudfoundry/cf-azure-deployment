resource "azurerm_virtual_machine" "bastion" {
  name                    = "${var.prefix}-bastion"
  depends_on              = ["module.it"]
  vm_size                 = "Standard_D1_v2"
  location                = "${var.location}"
  resource_group_name     = "${module.namings.resource-group-name}"
  network_interface_ids   = ["${module.it.bastion-nic-id}"]
  storage_image_reference = ["${var.latest_ubuntu}"]

  storage_os_disk {
    name              = "osdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
    disk_size_gb      = "50"
  }

  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys = [{
      path     = "/home/${var.ssh_user_username}/.ssh/authorized_keys"
      key_data = "${file(var.ssh_public_key_filename)}"
    }]
  }

  os_profile {
    computer_name  = "bastion"
    admin_username = "${var.ssh_user_username}"

    custom_data = <<CUSTOM_DATA
    {
      "VNET_NAME": "${module.namings.vnet-name}",
      "SUBNET_NAME_FOR_BOSH": "${module.namings.bosh-subnet-name}",
      "SUBNET_ADDRESS_RANGE_FOR_BOSH": "${module.it.bosh-subnet-address-prefix}",
      "SUBNET_NAME_FOR_CLOUD_FOUNDRY": "${module.namings.cf-subnet-name}",
      "SUBNET_ADDRESS_RANGE_FOR_CLOUD_FOUNDRY": "${module.it.cf-subnet-address-prefix}",
      "CLOUD_FOUNDRY_PUBLIC_IP":"${module.it.cf-public-ip-address}",
      "LOAD_BALANCER_NAME":"${module.namings.cf-balancer-name}",
      "NSG_NAME_FOR_BOSH": "${module.namings.bosh-sg-name}",
      "NSG_NAME_FOR_CLOUD_FOUNDRY":"${module.namings.cf-sg-name}",
      "SUBSCRIPTION_ID": "${var.subscription_id}",
      "RESOURCE_GROUP_NAME": "${module.namings.resource-group-name}",
      "DEFAULT_STORAGE_ACCOUNT_NAME":"${module.namings.bosh-default-storage-name}",
      "DEFAULT_STORAGE_ACCESS_KEY":"${module.it.bosh-default-storage-primary-key}",
      "ADMIN_USER_NAME": "${var.ssh_user_username}",
      "ENVIRONMENT": "AzureCloud",
      "SERVICE_HOST_BASE": "core.windows.net",
      "BOSH_AZURE_CPI_RELEASE_URL":"https://bosh.io/d/github.com/cloudfoundry-incubator/bosh-azure-cpi-release?v=35.2.0",
      "BOSH_AZURE_CPI_RELEASE_SHA1":"d581c4181d31846e05e59054a15e09621f1e90b1",
      "STEMCELL_URL":"https://opensourcerelease.blob.core.windows.net/stemcells/bosh-stemcell-2222.89-azure-hyperv-ubuntu-xenial-go_agent.tgz",
      "STEMCELL_SHA1":"2c5709ab761fe4f84fb364b9e4ac9367289f69e7",
      "BOSH_CLI_URL":"https://s3.amazonaws.com/bosh-cli-artifacts/bosh-cli-2.0.48-linux-amd64",
      "AUTO_DEPLOY_BOSH": "${var.auto_deploy_bosh}",
      "AUTO_DEPLOY_CLOUD_FOUNDRY":"${var.auto_deploy_cf}",
      "BOSH_VM_SIZE": "${var.bosh_vm_size}",
      "SERVICE_PRINCIPAL_TYPE": "Password",
      "USE_AVAILABILITY_ZONES": "${var.use_availability_zones}",
      "USE_VCONTAINER": "${var.use_vcontainer}",
      "DEBUG_MODE": "${var.debug_mode}",

      "ACI_LOCATION": "${var.location}",
      "ACI_RESOURCE_GROUP": "${module.namings.resource-group-name}",
      "ACI_STORAGE_ACCOUNT_NAME":  "${join("", azurerm_storage_account.aci-default-storage.*.name)}",
      "ACI_STORAGE_ACCOUNT_KEY": "${join("", azurerm_storage_account.aci-default-storage.*.primary_access_key)}",
      "SMB_PROXY_IP": "${var.aci_smb_proxy_ip}",
      "SMB_PROXY_PORT": "${var.aci_smb_proxy_port}"
    }
CUSTOM_DATA
  }
}
