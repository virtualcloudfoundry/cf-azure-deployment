#!/usr/bin/env bash

set -e

apt-get update
apt-get install -y build-essential zlibc zlib1g-dev ruby ruby-dev openssl libxslt-dev libxml2-dev libssl-dev libreadline6 libreadline6-dev libyaml-dev libsqlite3-dev sqlite3 jq git unzip
curl -o /tmp/cf.tgz https://s3.amazonaws.com/go-cli/releases/v6.20.0/cf-cli_6.20.0_linux_x86-64.tgz
tar -zxvf /tmp/cf.tgz && mv cf /usr/bin/cf && chmod +x /usr/bin/cf

custom_data_file="/var/lib/cloud/instance/user-data.txt"
settings=$(cat ${custom_data_file})
function get_setting() {
  key=$1
  local value=$(echo $settings | jq ".$key" -r)
  echo $value
}

# Vars
tenant_id=$(get_setting TENANT_ID)
client_id=$(get_setting CLIENT_ID)
client_secret=$(get_setting CLIENT_SECRET)
resource_group_name=$(get_setting RESOURCE_GROUP_NAME)
vnet_name=$(get_setting VNET_NAME)
cfcr_subnet_name=$(get_setting SUBNET_NAME_FOR_CFCR)
cfcr_master_sg_name=$(get_setting NSG_NAME_FOR_CFCR)
cfcr_subnet_address_range=$(get_setting SUBNET_ADDRESS_RANGE_FOR_CFCR)
cfcr_internal_ip=$(get_setting CFCR_INTERNAL_IP)
cfcr_internal_gw=$(get_setting CFCR_INTERNAL_GW)
location=$(get_setting LOCATION)
bosh_director_name=$(get_setting BOSH_DIRECTOR_NAME)
subscription_id=$(get_setting SUBSCRIPTION_ID)
kubernetes_master_host=$(get_setting KUBERNETES_MASTER_HOST)
kubernetes_master_port=$(get_setting KUBERNETES_MASTER_PORT)
master_target_pool=$(get_setting MASTER_TARGET_POOL)
allow_privileged_containers=$(get_setting ALLOW_PRIVILEGED_CONTAINERS)
disable_deny_escalating_exec=$(get_setting DISABLE_DENY_ESCALATING_EXEC)
cat > /etc/profile.d/bosh.sh <<EOF
#!/bin/bash

# Vars
export tenant_id=$tenant_id
export client_id=$client_id
export client_secret=$client_secret
export resource_group_name=$resource_group_name
export vnet_name=$vnet_name
export cfcr_subnet_name=$cfcr_subnet_name
export cfcr_master_sg_name=$cfcr_master_sg_name
export cfcr_subnet_address_range=$cfcr_subnet_address_range
export cfcr_internal_ip=$cfcr_internal_ip
export cfcr_internal_gw=$cfcr_internal_gw
export location=$location
export bosh_director_name=$bosh_director_name
export subscription_id=$subscription_id
export kubernetes_master_host=$kubernetes_master_host
export kubernetes_master_port=$kubernetes_master_port
export master_target_pool=$master_target_pool
export allow_privileged_containers=$allow_privileged_containers
export disable_deny_escalating_exec=$disable_deny_escalating_exec
EOF

cat > /usr/bin/update_azure_env <<'EOF'
#!/bin/bash

if [[ ! -f "$1" ]] || [[ ! "$1" =~ director.yml$ ]]; then
  echo 'Please specify the path to director.yml'
  exit 1
fi

# Azure specific updates
sed -i -e 's/^\(resource_group_name:\).*\(#.*\)/\1 '$resource_group_name' \2/' "$1"
sed -i -e 's/^\(vnet_resource_group_name:\).*\(#.*\)/\1 '$resource_group_name' \2/' "$1"
sed -i -e 's/^\(vnet_name:\).*\(#.*\)/\1 '$vnet_name' \2/' "$1"
sed -i -e 's/^\(subnet_name:\).*\(#.*\)/\1 '$cfcr_subnet_name' \2/' "$1"
sed -i -e 's/^\(location:\).*\(#.*\)/\1 '$location' \2/' "$1"
sed -i -e 's/^\(default_security_group:\).*\(#.*\)/\1 '$cfcr_master_sg_name' \2/' "$1"
sed -i -e 's/^\(master_vm_type:\).*\(#.*\)/\1 'master' \2/' "$1"
sed -i -e 's/^\(worker_vm_type:\).*\(#.*\)/\1 'worker' \2/' "$1"
sed -i -e 's/^\(allow_privileged_containers:\).*\(#.*\)/\1 '$allow_privileged_containers' \2/' "$1"
sed -i -e 's/^\(disable_deny_escalating_exec:\).*\(#.*\)/\1 '$disable_deny_escalating_exec' \2/' "$1"
# Generic updates
sed -i -e 's/^\(internal_ip:\).*\(#.*\)/\1 '$cfcr_internal_ip' \2/' "$1"
sed -i -e 's=^\(internal_cidr:\).*\(#.*\)=\1 '$cfcr_subnet_address_range' \2=' "$1"
sed -i -e 's/^\(internal_gw:\).*\(#.*\)/\1 '$cfcr_internal_gw' \2/' "$1"
sed -i -e 's/^\(director_name:\).*\(#.*\)/\1 '$bosh_director_name' \2/' "$1"

EOF
chmod a+x /usr/bin/update_azure_env

cat > /usr/bin/update_azure_secrets <<'EOF'
#!/bin/bash

if [[ ! -f "$1" ]] || [[ ! "$1" =~ director-secrets.yml$ ]]; then
  echo 'Please specify the path to director-secrets.yml'
  exit 1
fi

# Azure secrets updates
sed -i -e 's/^\(subscription_id:\).*\(#.*\)/\1 '$subscription_id' \2/' "$1"
sed -i -e 's=^\(tenant_id:\).*\(#.*\)=\1 '$tenant_id' \2=' "$1"
sed -i -e 's/^\(client_id:\).*\(#.*\)/\1 '$client_id' \2/' "$1"
sed -i -e 's/^\(client_secret:\).*\(#.*\)/\1 '$client_secret' \2/' "$1"

EOF
chmod a+x /usr/bin/update_azure_secrets


cat > /usr/bin/set_iaas_routing <<'EOF'
#!/bin/bash

if [[ ! -f "$1" ]] || [[ ! "$1" =~ director.yml$ ]]; then
  echo 'Please specify the path to director.yml'
  exit 1
fi

sed -i -e 's/^#* *\(routing_mode:.*\)$/# \1/' "$1"
sed -i -e 's/^#* *\(routing_mode:\) *\(iaas\).*$/\1 \2/' "$1"

sed -i -e "s/^\(kubernetes_master_host:\).*\(#.*\)/\1 '$kubernetes_master_host' \2/" "$1"
sed -i -e "s/^\(kubernetes_master_port:\).*\(#.*\)/\1 '${kubernetes_master_port:-8443}' \2/" "$1"
sed -i -e "s/^\(master_target_pool:\).*\(#.*\).*$/\1 '$master_target_pool' \2/" "$1"

EOF
chmod a+x /usr/bin/set_iaas_routing


# Get kubo-deployment
wget https://opensourcerelease.blob.core.windows.net/internalreleases/kubo-deployment.tgz
mkdir -p /share
tar -xvf kubo-deployment.tgz -C /share
chmod -R 777 /share

# Install Terraform
wget https://releases.hashicorp.com/terraform/0.7.7/terraform_0.7.7_linux_amd64.zip
unzip terraform*.zip -d /usr/local/bin

curl https://s3.amazonaws.com/bosh-cli-artifacts/bosh-cli-2.0.48-linux-amd64 -o /usr/bin/bosh
chmod a+x /usr/bin/bosh
curl -L https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl -o /usr/bin/kubectl
chmod a+x /usr/bin/kubectl
curl -L https://github.com/cloudfoundry-incubator/credhub-cli/releases/download/1.4.0/credhub-linux-1.4.0.tgz | tar zxv
chmod a+x credhub
mv credhub /usr/bin