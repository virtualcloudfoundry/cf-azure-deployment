variable "subscription_id" {}

variable "tenant_id" {}

variable "client_id" {}

variable "client_secret" {}

variable "location" {
  type    = "string"
  default = "southeastasia"
}

variable "prefix" {
  type = "string"
}

variable "network_cidr" {
  default = "10.0.0.0/16"
}
