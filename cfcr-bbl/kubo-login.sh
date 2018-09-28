#!/bin/sh
export api_hostname="$(bosh int ./vars/director-vars-file.yml --path /api-hostname)"

# you can use bosh env to get your director name.
./kubo_deployment/bin/set_kubeconfig <YOUR DIRECTOR NAME>/<YOUR DEPLOYMENT NAME> https://${api_hostname}:8443
