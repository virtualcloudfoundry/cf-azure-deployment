resource "azurerm_public_ip" "bastion" {
  name                         = "${var.prefix}-bastion-ip"
  location                     = "${var.location}"
  depends_on                   = ["azurerm_resource_group.rg"]
  resource_group_name          = "${azurerm_resource_group.rg.name}"
  public_ip_address_allocation = "static"
  sku                          = "Standard"

  tags {
    environment = "${module.variables.environment-tag}"
  }
}

// BOSH bastion host
resource "azurerm_network_interface" "bastion" {
  name                      = "${var.prefix}-bastion-nic"
  depends_on                = ["azurerm_public_ip.bastion", "azurerm_subnet.bosh-subnet", "azurerm_network_security_group.bastion"]
  location                  = "${var.location}"
  resource_group_name       = "${azurerm_resource_group.rg.name}"
  network_security_group_id = "${azurerm_network_security_group.bastion.id}"

  ip_configuration {
    name                          = "${var.prefix}-bastion-ip-config"
    subnet_id                     = "${azurerm_subnet.bosh-subnet.id}"
    private_ip_address_allocation = "static"
    private_ip_address            = "${cidrhost(azurerm_subnet.bosh-subnet.address_prefix,100)}"
    public_ip_address_id          = "${azurerm_public_ip.bastion.id}"
  }
}

resource "azurerm_virtual_machine" "bastion" {
  name                    = "${var.prefix}-bastion"
  depends_on              = ["azurerm_network_interface.bastion"]
  vm_size                 = "Standard_D1_v2"
  location                = "${var.location}"
  resource_group_name     = "${azurerm_resource_group.rg.name}"
  network_interface_ids   = ["${azurerm_network_interface.bastion.id}"]
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
      "TENANT_ID": "${var.tenant_id}",
      "CLIENT_ID": "${var.client_id}",
      "CLIENT_SECRET": "${var.client_secret}",
      "LOCATION": "${var.location}",
      "BOSH_DIRECTOR_NAME":"${var.bosh_director_name}",
      "VNET_NAME": "${module.variables.vnet-name}",
      "SUBNET_NAME_FOR_BOSH": "${module.variables.bosh-subnet-name}",
      "SUBNET_ADDRESS_RANGE_FOR_BOSH": "${azurerm_subnet.bosh-subnet.address_prefix}",
      "SUBNET_NAME_FOR_CFCR": "${azurerm_subnet.cfcr-subnet.name}",
      "SUBNET_ADDRESS_RANGE_FOR_CFCR": "${azurerm_subnet.cfcr-subnet.address_prefix}",
      "MASTER_TARGET_POOL": "${azurerm_lb.cfcr-balancer.name}",
      "KUBERNETES_MASTER_HOST": "${azurerm_public_ip.cfcr-balancer-ip.ip_address}",
      "KUBERNETES_MASTER_PORT": "${var.kubernetes_master_port}",
      "CFCR_INTERNAL_IP": "${cidrhost(azurerm_subnet.cfcr-subnet.address_prefix, 5)}",
      "CFCR_INTERNAL_GW": "${cidrhost(azurerm_subnet.cfcr-subnet.address_prefix, 1)}",
      "NSG_NAME_FOR_BOSH": "${azurerm_network_security_group.bosh.name}",
      "NSG_NAME_FOR_CFCR": "${azurerm_network_security_group.cfcr-master.name}",
      "SUBSCRIPTION_ID": "${var.subscription_id}",
      "RESOURCE_GROUP_NAME": "${azurerm_resource_group.rg.name}",
      "DEFAULT_STORAGE_ACCOUNT_NAME":"${azurerm_storage_account.bosh-default-storage.name}",
      "DEFAULT_STORAGE_ACCESS_KEY":"${azurerm_storage_account.bosh-default-storage.primary_access_key}",
      "ADMIN_USER_NAME": "${var.ssh_user_username}",
      "ENVIRONMENT": "AzureCloud",
      "SERVICE_HOST_BASE": "core.windows.net",
      "AUTO_DEPLOY_BOSH": "${var.auto_deploy_bosh}",
      "AUTO_DEPLOY_CFCR":"${var.auto_deploy_cfcr}",
      "BOSH_VM_SIZE": "${var.bosh_vm_size}",
      "SERVICE_PRINCIPAL_TYPE": "Password",
      "USE_AVAILABILITY_ZONES": "${var.use_availability_zones}",
      "DEBUG_MODE": "${var.debug_mode}"
    }
CUSTOM_DATA
  }
}
