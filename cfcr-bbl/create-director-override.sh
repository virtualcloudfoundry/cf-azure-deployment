#!/bin/sh
echo "create-env:"
bosh interpolate \
  ${BBL_STATE_DIR}/bosh-deployment/bosh.yml \
  --vars-store  ${BBL_STATE_DIR}/vars/director-vars-store.yml \
  --vars-file  ${BBL_STATE_DIR}/vars/director-vars-file.yml \
  -o  ${BBL_STATE_DIR}/bosh-deployment/azure/cpi.yml \
  -o  ${BBL_STATE_DIR}/bosh-deployment/azure/use-managed-disks.yml \
  -o  ${BBL_STATE_DIR}/bosh-deployment/jumpbox-user.yml \
  -o  ${BBL_STATE_DIR}/bosh-deployment/uaa.yml \
  -o  ${BBL_STATE_DIR}/bosh-deployment/credhub.yml \
  -o  ${BBL_STATE_DIR}/common-manifests/vm_director.yml \
  -o  ${BBL_STATE_DIR}/common-manifests/custom_cpi.yml \
  -v  subscription_id="${BBL_AZURE_SUBSCRIPTION_ID}" \
  -v  client_id="${BBL_AZURE_CLIENT_ID}" \
  -v  client_secret="${BBL_AZURE_CLIENT_SECRET}" \
  -v  tenant_id="${BBL_AZURE_TENANT_ID}"

bosh create-env \
  ${BBL_STATE_DIR}/bosh-deployment/bosh.yml \
  --state  ${BBL_STATE_DIR}/vars/bosh-state.json \
  --vars-store  ${BBL_STATE_DIR}/vars/director-vars-store.yml \
  --vars-file  ${BBL_STATE_DIR}/vars/director-vars-file.yml \
  -o  ${BBL_STATE_DIR}/bosh-deployment/azure/cpi.yml \
  -o  ${BBL_STATE_DIR}/bosh-deployment/azure/use-managed-disks.yml \
  -o  ${BBL_STATE_DIR}/bosh-deployment/jumpbox-user.yml \
  -o  ${BBL_STATE_DIR}/bosh-deployment/uaa.yml \
  -o  ${BBL_STATE_DIR}/bosh-deployment/credhub.yml \
  -o  ${BBL_STATE_DIR}/common-manifests/vm_director.yml \
  -o  ${BBL_STATE_DIR}/common-manifests/custom_cpi.yml \
  -v  subscription_id="${BBL_AZURE_SUBSCRIPTION_ID}" \
  -v  client_id="${BBL_AZURE_CLIENT_ID}" \
  -v  client_secret="${BBL_AZURE_CLIENT_SECRET}" \
  -v  tenant_id="${BBL_AZURE_TENANT_ID}"