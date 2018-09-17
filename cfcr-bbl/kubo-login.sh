#!/bin/sh
api_hostname="$(bosh int ./vars/director-vars-file.yml --path /api-hostname)"
# TODO get the director name dynamically.
./bin/set_kubeconfig bosh-andliu-cfo/azurecfcr https://${api_hostname}:8443
