export deployment_name='cf'
bosh update-config --name ${deployment_name} \
   ./cf-deployment/cf-cloud-config.yml \
   --type cloud



bosh -n update-cloud-config ~/example_manifests/cloud-config.yml \\
  -v internal_cidr=10.0.16.0/20 \\
  -v internal_gw=10.0.16.1 \\
  -v vnet_name=$(get_setting VNET_NAME) \\
  -v subnet_name=$(get_setting SUBNET_NAME_FOR_CLOUD_FOUNDRY) \\
  -v security_group=$(get_setting NSG_NAME_FOR_CLOUD_FOUNDRY) \\
  -v load_balancer_name=$(get_setting LOAD_BALANCER_NAME)

bosh -n -d cf deploy ~/example_manifests/cf-deployment.yml \\
  --vars-store=~/cf-deployment-vars.yml \\
  -o ~/example_manifests/azure.yml \\
  -o ~/example_manifests/scale-to-one-az.yml \\
  -o ~/example_manifests/small-vm.yml \\
  -o ~/example_manifests/use-compiled-releases.yml \\
  -o ~/example_manifests/use-azure-storage-blobstore.yml \\
  -v system_domain=$(get_setting CLOUD_FOUNDRY_PUBLIC_IP).xip.io \\
  -v environment=$(get_setting ENVIRONMENT) \\
  -v blobstore_storage_account_name=$(get_setting DEFAULT_STORAGE_ACCOUNT_NAME) \\
  -v blobstore_storage_access_key=$(get_setting DEFAULT_STORAGE_ACCESS_KEY) \\
  -v app_package_directory_key=cc-packages \\
  -v buildpack_directory_key=cc-buildpack \\
  -v droplet_directory_key=cc-droplet \\
  -v resource_directory_key=cc-resource \\