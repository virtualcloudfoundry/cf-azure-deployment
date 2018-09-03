resource "azurerm_virtual_machine" "bastion" {
  name                    = "${var.prefix}-bastion"
  depends_on              = ["module.it"]
  vm_size                 = "Basic_A1"
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
      "BOSH_AZURE_CPI_RELEASE_URL":"https://opensourcerelease.blob.core.windows.net/internalreleases/bosh-azure-cpi-vmss-vhd-release.tgz",
      "BOSH_AZURE_CPI_RELEASE_SHA1":"3a1c9a3cd0a94b489a59ee2c55dd1e0a185f3569",
      "STEMCELL_URL":"https://bosh.io/d/stemcells/bosh-azure-hyperv-ubuntu-trusty-go_agent?v=3586.24",
      "STEMCELL_SHA1":"ddafd98aad041bc2a92fae0168ab98f2adec331e",
      "BOSH_CLI_URL":"https://s3.amazonaws.com/bosh-cli-artifacts/bosh-cli-2.0.48-linux-amd64",
      "AUTO_DEPLOY_BOSH": "${var.auto_deploy_bosh}",
      "AUTO_DEPLOY_CLOUD_FOUNDRY":"${var.auto_deploy_cf}",
      "BOSH_VM_SIZE": "${var.bosh_vm_size}",
      "SERVICE_PRINCIPAL_TYPE": "Password",
      "USE_AVAILABILITY_ZONES": "${var.use_availability_zones}",
      "USE_VMSS": "${var.use_vmss}"
    }
CUSTOM_DATA
  }
}
