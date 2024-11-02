#!/bin/bash

set -e 

cd terraform

terraform init -backend-config="key=vpc/staging.tfstate" -backend-config="bucket=app-runner-poc-staging-terraform-state" -input=false

# deploy ECR IAC if needed as app runner depends on docker image being up
terraform apply -auto-approve -target=aws_ecr_repository.application_ecr_repo -var-file envs/staging.tfvars
