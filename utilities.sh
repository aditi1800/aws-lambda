#!/bin/bash

# get Status of Stack for a given StackName
getStackStatus() {
    StackStatus=""
    StackName=$1
    StackStatus="$(aws cloudformation describe-stacks \
        --query 'Stacks[?StackName==`"'$StackName'"`].StackStatus' \
        --output text)"
    if [[ -n "$StackStatus" ]]; then
        echo "$StackStatus"
    else
        echo ""
    fi
}

# get SecretString of given Secret Name i.e. SecretId
getSecretString() {
    SecretStringJson=""
    SecretId=$1
    # echo "secretStringId = $SecretId"
    SecretStringJson="$(aws secretsmanager get-secret-value \
        --secret-id "$SecretId" \
        --query "SecretString" \
        --output text)"
    # echo "secretStringValue = $SecretStringJson"
    if [[ -n "$SecretStringJson" ]]; then
        echo "$SecretStringJson"
    else
        echo ""
    fi
}

# get Stack Outputs
getStackOutputs() {
    StackOutputs=""
    StackName=$1
    StackOutputs="$(aws cloudformation describe-stacks \
        --query 'Stacks[?StackName==`"'$StackName'"`].Outputs[*]' \
        --output text)"
    if [[ -n "$StackOutputs" ]]; then
        echo "$StackOutputs"
    else
        echo ""
    fi
}
