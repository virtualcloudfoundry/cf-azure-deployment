## How to Deploy CFCR

### Step 1: deploy bastion vm.
terraform apply -var prefix="YOUR PREFIX FOR RESOURCES" -var subscription_id="YOUR SUBSCRIPTION ID" -var client_id="YOUR SERVICE PRINCIPAL ID" -var client_secret="YOUR SERVICE PRINCIPAL PASSWORD" -var tenant_id="YOUR TENANT ID" -var ssh_user_username="cfuser" -var ssh_public_key_filename="./ssh_key.pub"

### Step 2: connec to the bastion vm, and run.
a. deploy the bosh director:
cd /share/kubo-deployment
export kubo_envs=~/kubo-env
export kubo_env_name=kubo
export kubo_env_path="${kubo_envs}/${kubo_env_name}"
mkdir -p "${kubo_envs}"
./bin/generate_env_config "${kubo_envs}" "${kubo_env_name}" azure
/usr/bin/update_azure_env "${kubo_env_path}/director.yml"
/usr/bin/update_azure_secrets "${kubo_env_path}/director-secrets.yml"
/usr/bin/set_iaas_routing "${kubo_env_path}/director.yml"
/share/kubo-deployment/bin/deploy_bosh "${kubo_env_path}"

b. deploy the cfcr
BOSH_ENV=${kubo_env_path} 
source /share/kubo-deployment/bin/set_bosh_environment
./bin/deploy_k8s ~/kubo-env/kubo my-cluster
./bin/set_kubeconfig ~/kubo-env/kubo my-cluster
kubectl get pods --namespace=kube-system

c. run the test app
kubectl create -f https://raw.githubusercontent.com/andyzhangx/demo/dynamic_ip/pv/storageclass-azurefile.yaml
kubectl create -f https://raw.githubusercontent.com/andyzhangx/demo/dynamic_ip/demo/nginx-server/nginx-server-azurefile.yaml