### Did modifications to the default bbl folder structures:
1. cf-deployment folder
2. cloud-config/cf-cloud-config.yml
3. terraform/cf.tf

<!-- https://github.com/cloudfoundry/bosh-bootloader/tree/master/plan-patches/byoresource-group-azure -->

### Steps to deployment
#### update cloud config
<!-- eval "$(bbl print-env)"
export deployment_name='cf'
bosh update-config --name ${deployment_name} \
   ./cf-deployment/cf-cloud-config.yml \
   --type cloud
   -v vnet_name=andliu-cflite-vn \
   -v cf_subnet=andliu-cflite-cf-sn \
   -v cf_subnet_cidr=10.0.16.0/20 \
   -v cf_internal_gw=10.0.16.1 \ -->

#### deployment cf lite.


#### deployment cf.
