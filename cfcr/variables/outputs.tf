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

output "cfcr-subnet-name" {
  value = "${var.prefix}-cfcr-subnet"
}

output "prv-dns-name" {
  value = "${var.prefix}-dns.internal"
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

output "cfcr-master-sg-name" {
  value = "${var.prefix}-cfcr-master-sg"
}
