### Did modifications to the default bbl folder structures:
1. cf-deployment folder
2. cloud-config/cf-cloud-config.yml
3. terraform/cf.tf


### Steps to deployment
#### update cloud config
eval "$(bbl print-env)"
export deployment_name='cf'
bosh update-config --name ${deployment_name} \
   ./cf-deployment/cf-cloud-config.yml \
   --type cloud
   -v vnet_name=andliu-cflite-vn \
   -v cf_subnet=andliu-cflite-cf-sn \
   -v cf_subnet_cidr=10.0.16.0/20 \
   -v cf_internal_gw=10.0.16.1 \

#### deployment cf lite.
bosh -n -d cf deploy ./cf-deployment/cf-deployment.yml \\
  --vars-store=~/cf-deployment-vars.yml \\
  -o ~/example_manifests/azure.yml \\
  <!-- -o ~/example_manifests/scale-to-one-az.yml \\ -->
  <!-- -o ~/example_manifests/small-vm.yml \\ -->
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