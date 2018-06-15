# Deployment steps.
Actually we have two ways to deploy the cf-lite environment:

# Deploy the cf-lite environment using azure vms.




# Deploy the cf-lite environment using local bosh.

## Step 1: prepare one dev box (maybe you already have that)
### Install one Ubuntu machine.
### Install Virtual Box 5.1+

__DO NOT__ simply use `apt-get install virtualbox` directly. In this way `VirtualBox 5.0` will be installed, which has a buggy implement for NAT network and will make your bosh director unable to access network.

```
# add the official repository
wget -q -O - https://www.virtualbox.org/download/oracle_vbox_2016.asc | sudo apt-key add -
echo deb http://download.virtualbox.org/virtualbox/debian `lsb_release -cs` non-free contrib | sudo tee /etc/apt/sources.list.d/virtualbox.org.list

# install the newer version of virtualbox
sudo apt-get update
sudo apt-get install virtualbox-5.1
```
### Install Bosh CLI

```
# download
wget https://s3.amazonaws.com/bosh-cli-artifacts/bosh-cli-2.0.28-linux-amd64
chmod +x bosh-cli-2.0.28-linux-amd64

# move to path
sudo mv bosh-cli-2.0.28-linux-amd64 /usr/local/bin/bosh

# print version to verify
bosh -v

# install dependencies for `create-env`
sudo apt-get install -y build-essential zlibc zlib1g-dev ruby ruby-dev openssl libxslt-dev libxml2-dev libssl-dev libreadline6 libreadline6-dev libyaml-dev libsqlite3-dev sqlite3
```

### Install CF CLI

```
# add CF foundation's repository and public key
wget -q -O - https://packages.cloudfoundry.org/debian/cli.cloudfoundry.org.key | sudo apt-key add -
echo "deb http://packages.cloudfoundry.org/debian stable main" | sudo tee /etc/apt/sources.list.d/cloudfoundry-cli.list

# install CF CLI
sudo apt-get update
sudo apt-get install cf-cli
```

## Deploy bosh-lite

```
# clone bosh deployment
git clone https://github.com/cloudfoundry/bosh-deployment
cd bosh-deployment

# create bosh environment
bosh create-env bosh.yml --state ./state.json -o virtualbox/cpi.yml -o virtualbox/outbound-network.yml -o bosh-lite.yml -o bosh-lite-runc.yml -o jumpbox-user.yml --vars-store ./creds.yml -v director_name="Bosh Lite Director" -v internal_ip=192.168.50.6 -v internal_gw=192.168.50.1 -v internal_cidr=192.168.50.0/24 -v outbound_network_name=NatNetwork

# setup alias for environment
bosh -e 192.168.50.6 --ca-cert <(bosh int ./creds.yml --path /director_ssl/ca) alias-env vbox

# setup credential as environment variables
export BOSH_CLIENT=admin
export BOSH_CLIENT_SECRET=`bosh int ./creds.yml --path /admin_password`

# setup route
sudo route add -net 10.244.0.0/16 gw 192.168.50.6 # Linux


# create key for ssh connection
bosh int ./creds.yml --path /jumpbox_ssh/private_key > ~/.ssh/bosh-virtualbox.key
chmod 600 ~/.ssh/bosh-virtualbox.key

# SSH to your bosh director to verify
ssh -i ~/.ssh/bosh-virtualbox.key jumpbox@192.168.50.6
```
## Deploy cf-lite
```
# clone cf deployment
git clone https://github.com/virtualcloudfoundry/cf-azure-deployment
cd cf-lite

# upload stemcell
bosh -e vbox upload-stemcell https://bosh.io/d/stemcells/bosh-warden-boshlite-ubuntu-trusty-go_agent?v=3541.10

# setup config file
bosh -e vbox update-cloud-config ./cf-lite/manifests/cloud-config.yml

# deploy cf

```

##### MacOS:

#### Step 2: deploy bosh-lite