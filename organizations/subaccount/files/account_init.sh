#!/bin/bash

# This script initializes newly created AWS accounts with a Cloudformation init template.
# It is executed by a null_resource and should only trigger once per account.

# Don't echo commands and error on any issues with auth/assume role
set +x
set -e

# Wait a bit before proceeding - the script will invoke right after the account is created but sometimes takes a few seconds
sleep 30

# Assume a role into the Master AWS account
TEMPCREDS=$(aws sts assume-role --duration-seconds 900 \
  --role-arn arn:aws:iam::${MASTER_ACCOUNT_ID}:role/${MASTER_ACCOUNT_ROLE} \
  --role-session-name terraform-auto-account-provisioning)
export AWS_ACCESS_KEY_ID=$(echo $TEMPCREDS | jq -r '.Credentials.AccessKeyId')
export AWS_SECRET_ACCESS_KEY=$(echo $TEMPCREDS | jq -r '.Credentials.SecretAccessKey')
export AWS_SESSION_TOKEN=$(echo $TEMPCREDS | jq -r '.Credentials.SessionToken')

# Assume another role through the Master into the newly provisioned account
TEMPCREDS=$(aws sts assume-role --duration-seconds 900 \
  --role-arn arn:aws:iam::${ACCOUNT_ID}:role/${ROLE_NAME} \
  --role-session-name terraform-auto-account-provisioning)
export AWS_ACCESS_KEY_ID=$(echo $TEMPCREDS | jq -r '.Credentials.AccessKeyId')
export AWS_SECRET_ACCESS_KEY=$(echo $TEMPCREDS | jq -r '.Credentials.SecretAccessKey')
export AWS_SESSION_TOKEN=$(echo $TEMPCREDS | jq -r '.Credentials.SessionToken')

set -x
# Now echo commands and don't error because for some reason 0> codes can be expected with `aws cloudformation deploy`
set +e

# Deploy a Cloudformation stack to the new account to initialize the access roles
aws cloudformation deploy \
    --stack-name "${STACK_NAME}" \
    --template-file "${FILE_PATH}" \
    --parameter-overrides "Account=${ACCOUNT_NAME}" \
    --capabilities "CAPABILITY_NAMED_IAM" \
    --region "${REGION}"

exit 0
