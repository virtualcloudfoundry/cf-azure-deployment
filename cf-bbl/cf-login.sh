#!/bin/sh

cf_admin_password="$(bosh int ./vars/cf-deployment-vars.yml --path /cf_admin_password)"

cf login -a https://api.$(get_setting CLOUD_FOUNDRY_PUBLIC_IP).xip.io -u admin -p "\${cf_admin_password}" --skip-ssl-validation
