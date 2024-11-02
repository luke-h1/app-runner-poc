#!/bin/bash

set -e

cd terraform


terraform validate
terraform plan -out=tfplan -var-file envs/staging.tfvars



echo "Do you want to apply the changes? (Y/N)"
select yn in "Y" "N"; do
      case $yn in
          Y ) terraform apply tfplan; break;;        
          N ) exit;;
        * ) echo "Please select 1 for Y or 2 for N.";;
    esac
done