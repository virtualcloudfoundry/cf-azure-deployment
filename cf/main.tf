variable "subscription_id" {}

variable "tenant_id" {}

variable "client_id" {}

variable "client_secret" {}

variable "latest_ubuntu" {
  type = "map"

  default = {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04.0-LTS"
    version   = "latest"
  }
}

variable "ssh_user_username" {
  type    = "string"
  default = "ubuntu"
}

# variable "ssh_private_key_filename" {
#   type = "string"
# }

variable "ssh_public_key_filename" {
  type = "string"
}

variable "location" {
  type    = "string"
  default = "eastasia"
}

variable "prefix" {
  type = "string"
}

variable "bosh_vm_size" {
  type    = "string"
  default = "Standard_D1_v2"
}

variable "network_cidr" {
  default = "10.0.0.0/16"
}

variable "auto_deploy_bosh" {
  default     = "enabled"
  description = "enabled or disabled"
}

variable "auto_deploy_cf" {
  default     = "disabled"
  description = "enabled or disabled"
}

variable "use_availability_zones" {
  type        = "string"
  default     = "disabled"
  description = "enabled or disabled"
}

provider "azurerm" {
  subscription_id = "${var.subscription_id}"
  tenant_id       = "${var.tenant_id}"
  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
}

module "variables" {
  source = "./variables"
  prefix = "${var.prefix}"
}
