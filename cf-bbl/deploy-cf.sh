bosh upload-stemcell --sha1=073edfb9315aa318c24c0b9968dd9e30c73fe409 https://opensourcerelease.blob.core.windows.net/releases/bosh-stemcell-6666.66-azure-hyperv-ubuntu-xenial-go_agent.tgz
bosh -n -d cf deploy ./cf-deployment/cf-deployment.yml \
  --vars-store=./vars/cf-deployment-vars.yml \
  -o ./cf-deployment/gorouter-azure.yml \
  -o ./cf-deployment/use-azure-storage-blobstore.yml \
  --vars-file=./vars/director-vars-file.yml \
  -v environment=AzurePublic \
  -v app_package_directory_key=cc-packages \
  -v buildpack_directory_key=cc-buildpack \
  -v droplet_directory_key=cc-droplet \
  -v resource_directory_key=cc-resource