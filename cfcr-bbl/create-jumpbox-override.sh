#!/bin/sh
echo "create-env:"
bosh interpolate \
  ${BBL_STATE_DIR}/jumpbox-deployment/jumpbox.yml \
  --vars-store  ${BBL_STATE_DIR}/vars/jumpbox-vars-store.yml \
  --vars-file  ${BBL_STATE_DIR}/vars/jumpbox-vars-file.yml \
  -o  ${BBL_STATE_DIR}/jumpbox-deployment/azure/cpi.yml \
  -o  ${BBL_STATE_DIR}/common-manifests/vm_jumpbox.yml \
  -o  ${BBL_STATE_DIR}/common-manifests/use_managed_disk.yml \
  -o  ${BBL_STATE_DIR}/common-manifests/custom_cpi.yml \
  -v  subscription_id="${BBL_AZURE_SUBSCRIPTION_ID}" \
  -v  client_id="${BBL_AZURE_CLIENT_ID}" \
  -v  client_secret="${BBL_AZURE_CLIENT_SECRET}" \
  -v  tenant_id="${BBL_AZURE_TENANT_ID}"

bosh create-env \
  ${BBL_STATE_DIR}/jumpbox-deployment/jumpbox.yml \
  --state  ${BBL_STATE_DIR}/vars/jumpbox-state.json \
  --vars-store  ${BBL_STATE_DIR}/vars/jumpbox-vars-store.yml \
  --vars-file  ${BBL_STATE_DIR}/vars/jumpbox-vars-file.yml \
  -o  ${BBL_STATE_DIR}/jumpbox-deployment/azure/cpi.yml \
  -o  ${BBL_STATE_DIR}/common-manifests/vm_jumpbox.yml \
  -o  ${BBL_STATE_DIR}/common-manifests/use_managed_disk.yml \
  -o  ${BBL_STATE_DIR}/common-manifests/custom_cpi.yml \
  -v  subscription_id="${BBL_AZURE_SUBSCRIPTION_ID}" \
  -v  client_id="${BBL_AZURE_CLIENT_ID}" \
  -v  client_secret="${BBL_AZURE_CLIENT_SECRET}" \
  -v  tenant_id="${BBL_AZURE_TENANT_ID}"