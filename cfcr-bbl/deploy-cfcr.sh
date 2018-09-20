#!/bin/sh
bosh upload-stemcell --sha1=073edfb9315aa318c24c0b9968dd9e30c73fe409 https://opensourcerelease.blob.core.windows.net/releases/bosh-stemcell-6666.66-azure-hyperv-ubuntu-xenial-go_agent.tgz

bosh deploy -d azurecfcr ./cfcr_manifests/cfcr.yml \
    --vars-file=./vars/director-vars-file.yml \
    -o ./cfcr_manifests/ops-files/iaas/azure/cloud-provider.yml \
    -o ./cfcr_manifests/ops-files/misc/single-master.yml \
    -o ./cfcr_manifests/ops-files/add-hostname-to-master-certificate.yml \
    -o ./cfcr_manifests/ops-files/kubo-local-release.yml \
    -o ./cfcr_manifests/ops-files/rename.yml \
    -o ./cfcr_manifests/ops-files/use-vm-extensions.yml \
    -o ./cfcr_manifests/ops-files/misc/small-vm.yml \
    -o ./cfcr_manifests/ops-files/iaas/azure/subnet.yml \
    -v deployment_name=azurecfcr \
    -v subscription_id="${BBL_AZURE_SUBSCRIPTION_ID}" \
    -v client_id="${BBL_AZURE_CLIENT_ID}" \
    -v client_secret="${BBL_AZURE_CLIENT_SECRET}" \
    -v tenant_id="${BBL_AZURE_TENANT_ID}"
