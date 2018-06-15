output "resource-group-name" {
  value = "${var.prefix}-rg"
}

output "environment-tag" {
  value = "${var.prefix}-env"
}

output "vnet-name" {
  value = "${var.prefix}-vnet"
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

output "bastion-sg-name" {
  value = "${var.prefix}-bastion-sg"
}

output "bosh-sg-name" {
  value = "${var.prefix}-bosh-sg"
}

output "cf-sg-name" {
  value = "${var.prefix}-cf-sg"
}
