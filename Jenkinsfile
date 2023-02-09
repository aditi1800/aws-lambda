pipeline {
    agent any

    parameters {
        // ingvalidatingString(name: 'InstanceName', defaultValue: '', regex: '^.+?-.+?-.+?', failedValidationMessage: 'Validation failed! : Enter instance name in format: wo-<env>-<instance>', description: 'Instance Name usually follows naming convention wo-<env>-<instance>. Ex.env must be dev or sandbox and instance should be cluster name suffix like wo-dev-lcap.')
        string(name: 'InstanceName', defaultValue: 'wo-dp-mir', description: '')
        string(name: 'VpcId', defaultValue: 'vpc-0d7a53624b6d52e6a', description: '')
        choice(name: 'region', choices: ['us-east-1', 'us-west-2', 'ca-central-1', 'us-east-2', 'us-west-1', 'sa-east-1', 'ap-southeast-1', 'ap-southeast-2', 'ap-southeast-3', 'ap-south-1', 'ap-east-1', 'ap-northeast-1', 'ap-northeast-2', 'ap-northeast-3', 'eu-west-1', 'eu-central-1', 'eu-north-1', 'eu-west-2', 'eu-west-3', 'eu-south-1', 'me-south-1', 'af-south-1'], description: 'Select AWS Region in which cluster needs to be deployed.')
    }

    environment {
        AWS_ACCESS_KEY_ID = credentials('demo-id')
        AWS_SECRET_ACCESS_KEY = credentials('demo-key')
        // AWS_SESSION_TOKEN = credentials('demo-token')
        AWS_DEFAULT_REGION = "${region}"
        createUtilStack = "${sh(returnStdout: true, script: "aws cloudformation create-stack --stack-name $InstanceName-util --region $region --template-body file://util-template.yaml --capabilities CAPABILITY_NAMED_IAM --parameters ParameterKey=VPCId,ParameterValue=$VpcId ParameterKey=InstanceName,ParameterValue=$InstanceName | tr -d '\n'")}"
    // utilStackOutput = "${sh(returnStdout: true, script: "aws cloudformation describe-stacks --stack-name $InstanceName-util --region $region  --output json --query 'Stacks[0].Outputs[*]["OutputValue"]' | tr -d '\n'")}"
    // subnetIDs = "${sh(returnStdout: true, script: "aws cloudformation describe-stacks --stack-name $InstanceName-util --region $region  --output json --query 'Stacks[0].Outputs[?OutputKey==`GetSubnetIDs`].OutputValue | [0]' | tr -d '\n'")}"
    // securityGroupIDs = "${sh(returnStdout: true, script: "aws cloudformation describe-stacks --stack-name $InstanceName-util --region $region  --output json --query 'Stacks[0].Outputs[?OutputKey==`GetSecurityGroupIDs`].OutputValue | [0]' | tr -d '\n'")}"
    // KINESIS_APPLICATION_NAME = "${InstanceName}"
    }

    stages {
        stage('Check util cft creation') {
            steps {
                catchError(buildResult: 'FAILURE', stageResult: 'FAILURE') {
                    sh '''#!/bin/bash
                    chmod +x utilities.sh
                    export STACKNAME=${InstanceName}-util
                    . ./utilities.sh
                    StackCreated="false"
                    while [[ $StackCreated == "false" ]]; do
                      StackStatus="$(getStackStatus "$STACKNAME")"
                      echo "StackStatus:$StackStatus"
                      # Check Stack State - expected is CREATE_COMPLETE
                      if [[ $StackStatus == "CREATE_COMPLETE" ]]; then
                          StackCreated="true"
                          break
                      else
                         echo "Sleeping for 1m, and retrying.."
                         sleep 1m
                         StackCreated="false"
                         continue
                      fi
                    done
                    '''
                }
            }
        }
        stage('Get IDs') {
            steps {
                catchError(buildResult: 'FAILURE', stageResult: 'FAILURE') {
                    sh '''#!/bin/bash
                    subnetIDs="$(aws cloudformation describe-stacks --stack-name $InstanceName-util \
                                --output json --query 'Stacks[0].Outputs[?OutputKey==`GetSubnetIDs`].OutputValue | [0]' )"
                    securityGroupID="$(aws cloudformation describe-stacks --stack-name $InstanceName-util \
                                 --output json --query 'Stacks[0].Outputs[?OutputKey==`GetSecurityGroupIDs`].OutputValue | [0]')"
                    echo "Subnet ID : $subnetIDs"
                    echo " SecurityGroup ID : $securityGroupID"
                    '''
                }
            }
        }
    }
}
