#!/bin/sh

cf_system_domain="$(bosh int ./vars/director-vars-file.yml --path /system_domain)"
cf_admin_password="$(bosh int ./vars/cf-deployment-vars.yml --path /cf_admin_password)"

cf login -a https://api.$cf_system_domain -u admin -p "${cf_admin_password}" --skip-ssl-validation
