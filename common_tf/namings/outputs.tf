output "resource-group-name" {
  value = "${var.prefix}-rg"
}

output "environment-tag" {
  value = "${var.prefix}-env"
}

output "vnet-name" {
  value = "${var.prefix}-vnet"
}

output "bosh-default-storage-name" {
  value = "${replace(lower(var.prefix), "/[^0-9a-z]/","")}"
}

output "bosh-subnet-name" {
  value = "${var.prefix}-bosh-subnet"
}

output "cf-subnet-name" {
  value = "${var.prefix}-cf-subnet"
}

output "bastion-name" {
  value = "${var.prefix}-bastion"
}

output "bastion-nic-name" {
  value = "${var.prefix}-bastion-nic"
}

output "bastion-ip-name" {
  value = "${var.prefix}-bastion-ip"
}

output "bastion-sg-name" {
  value = "${var.prefix}-bastion-sg"
}

output "bosh-sg-name" {
  value = "${var.prefix}-bosh-sg"
}

output "cf-sg-name" {
  value = "${var.prefix}-cf-sg"
}

output "cf-balancer-name" {
  value = "${var.prefix}-cf-balancer"
}

output "cf-balancer-public-ip-name" {
  value = "${var.prefix}-cf-public-ip"
}
