output "resource-group-name" {
  value = "${var.prefix}-rg"
}

output "environment-tag" {
  value = "${var.prefix}-env"
}

output "vnet-name" {
  value = "${var.prefix}-vnet"
}

output "cfcr-subnet-name" {
  value = "${var.prefix}-cfcr-subnet"
}

output "prv-dns-name" {
  value = "${var.prefix}-dns.internal"
}

output "cfcr-master-sg-name" {
  value = "${var.prefix}-cfcr-master-sg"
}
