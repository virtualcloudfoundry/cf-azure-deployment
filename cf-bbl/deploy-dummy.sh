bosh upload-stemcell --sha1=073edfb9315aa318c24c0b9968dd9e30c73fe409 https://opensourcerelease.blob.core.windows.net/releases/bosh-stemcell-6666.66-azure-hyperv-ubuntu-xenial-go_agent.tgz
bosh -n -d dummy deploy ./dummy-deployment/dummy-deployment.yml \
  --vars-store=./vars/dummy-deployment-vars.yml \
  -o ./dummy-deployment/use_vmss.yml