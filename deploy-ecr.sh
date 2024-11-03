#!/bin/bash

set -e 

cd terraform

terraform init -backend-config="key=vpc/staging.tfstate" -backend-config="bucket=app-runner-poc-staging-terraform-state" -input=false

# deploy ECR IAC if needed as app runner depends on docker image being up
terraform apply -auto-approve -target=aws_ecr_repository.application_ecr_repo -var-file envs/staging.tfvars


# build and push docker image to ECR
cd ..

aws ecr get-login-password --region eu-west-2 | docker login --username AWS --password-stdin 753493924839.dkr.ecr.eu-west-2.amazonaws.com

docker build -t app-runner-poc .

docker tag app-runner-poc:latest 753493924839.dkr.ecr.eu-west-2.amazonaws.com/app-runner-poc:latest
docker push 753493924839.dkr.ecr.eu-west-2.amazonaws.com/app-runner-poc:latest