#!/bin/bash

PROFILE="cloud_user"

# Check if AWS Account ID is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <aws_account_id>"
  exit 1
fi

AWS_ACCOUNT_ID="$1"

# Extract the default region from the AWS configuration
AWS_REGION=$(grep -m 1 'region' ~/.aws/config | awk '{print $3}')

# Verify region is found
if [ -z "$AWS_REGION" ]; then
  echo "AWS region not found in ~/.aws/config. Please set it up."
  exit 1
fi

# Authenticate Docker with AWS ECR
echo "Authenticating Docker with AWS ECR in region $AWS_REGION for account $AWS_ACCOUNT_ID..."
aws ecr get-login-password --region "$AWS_REGION" --profile $PROFILE | docker login --username AWS --password-stdin "$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com"

if [ $? -eq 0 ]; then
  echo "Successfully authenticated Docker with AWS ECR."
else
  echo "Authentication failed. Please check your AWS credentials and region."
  exit 1
fi
