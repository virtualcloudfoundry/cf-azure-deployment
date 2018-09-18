bosh -n -d cflite deploy ./cf-lite-deployment/cf-deployment.yml \
  --vars-store=./vars/cf-lite-deployment-vars.yml \
  -o ./cf-lite-deployment/gorouter-azure.yml \
  -o ./cf-lite-deployment/use-azure-storage-blobstore.yml \
  --vars-file=./vars/director-vars-file.yml \
  -v environment=AzurePublic \
  -v app_package_directory_key=cc-packages \
  -v buildpack_directory_key=cc-buildpack \
  -v droplet_directory_key=cc-droplet \
  -v resource_directory_key=cc-resource