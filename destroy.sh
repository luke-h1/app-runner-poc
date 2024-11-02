#!/bin/bash

set -e

cd terraform


terraform validate



echo "Do you want to destroy? (Y/N)"
select yn in "Y" "N"; do
      case $yn in
          Y ) terraform destroy -auto-approve -var-file envs/staging.tfvars; break;;        
          N ) exit;;
        * ) echo "Please select 1 for Y or 2 for N.";;
    esac
done