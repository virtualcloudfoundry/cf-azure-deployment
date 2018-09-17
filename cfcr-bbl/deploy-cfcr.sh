#!/bin/sh
bosh upload-stemcell --sha1=073edfb9315aa318c24c0b9968dd9e30c73fe409 https://opensourcerelease.blob.core.windows.net/releases/bosh-stemcell-6666.66-azure-hyperv-ubuntu-xenial-go_agent.tgz

# create one cloud config specific to the deployment
export deployment_name="azurecfcr"
bosh -n update-config --name ${deployment_name} \
   ./kubo-deployment/manifests/cloud-config/iaas/azure/use-vm-extensions.yml \
   --type cloud \
   --vars-file=./vars/director-vars-file.yml \
   -v deployment_name=${deployment_name}

bosh -n deploy -d ${deployment_name} ./kubo-deployment/manifests/cfcr.yml \
    --vars-file=./vars/director-vars-file.yml \
    -o ./kubo-deployment/manifests/ops-files/iaas/azure/cloud-provider.yml \
    -o ./kubo-deployment/manifests/ops-files/misc/single-master.yml \
    -o ./kubo-deployment/manifests/ops-files/add-hostname-to-master-certificate.yml \
    -o ./kubo-deployment/manifests/ops-files/rename.yml \
    -o ./kubo-deployment/manifests/ops-files/use-vm-extensions.yml \
    -o ./kubo-deployment/customize_kubo_release.yml \
    -o ./kubo-deployment/manifests/ops-files/misc/small-vm.yml \
    -o ./kubo-deployment/manifests/ops-files/iaas/azure/subnet.yml \
    -v azure_cloud_name="AzurePublicCloud" \
    -v primary_availability_set="bosh-andliu-cfo-azurecfcr-worker" \
    -v deployment_name=${deployment_name} \
    -v subscription_id="${BBL_AZURE_SUBSCRIPTION_ID}" \
    -v client_id="${BBL_AZURE_CLIENT_ID}" \
    -v client_secret="${BBL_AZURE_CLIENT_SECRET}" \
    -v tenant_id="${BBL_AZURE_TENANT_ID}"
