#!/bin/bash
set -ex

GITHUB_ACTIONS=$1
GITHUB_REPOSITORY_NAME=$2
GITHUB_BRANCH_NAME=$3
GITHUB_AWS_ACCOUNT_ID=$4
GITHUB_AWS_REGION=$5

printenv 

##
## Setup Pipeline Compose Environment
##
if [[ "${GITHUB_BRANCH_NAME}" =~ ^(develop)$ ]]; then
  export PIPELINE_COMPOSE_ENVIRONMENT=dev
elif  [[ "${GITHUB_BRANCH_NAME}" =~ ^(main)$ ]]; then
  export PIPELINE_COMPOSE_ENVIRONMENT=production
fi

##
## Setup AWS ECR authentication
##
aws ecr get-login-password --region "${GITHUB_AWS_REGION}" | docker login --username AWS --password-stdin "${GITHUB_AWS_ACCOUNT_ID}".dkr.ecr.ap-southeast-1.amazonaws.com

if [[ "$?" -eq 0 ]]; then
  echo "AWS Elastic Container Registry Authenticated."
else
  echo "AWS Elastic Container Registry Authenticate."
fi

##
## Deploy Application
##
if [[ "$GITHUB_ACTIONS" == true ]]; then
  echo "Docker Image Latest Version Downloading..."
  docker-compose -f "${PIPELINE_COMPOSE_ENVIRONMENT}"-simple-web/docker-compose.yml pull
  echo "Docker Image Latest Version Download Success."

  echo "Application Deploying..."
  docker-compose -f "${PIPELINE_COMPOSE_ENVIRONMENT}"-simple-web/docker-compose.yml up -d

  if [[ "$?" -eq 0 ]]; then
    echo "Application Deployed.."
    rm -rf "${GITHUB_REPOSITORY_NAME}"
  else
    echo "Application FAILED."
    rm -rf "${GITHUB_REPOSITORY_NAME}"
  fi
fi
