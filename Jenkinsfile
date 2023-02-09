pipeline {
    agent any

    parameters {
        // ingvalidatingString(name: 'InstanceName', defaultValue: '', regex: '^.+?-.+?-.+?', failedValidationMessage: 'Validation failed! : Enter instance name in format: wo-<env>-<instance>', description: 'Instance Name usually follows naming convention wo-<env>-<instance>. Ex.env must be dev or sandbox and instance should be cluster name suffix like wo-dev-lcap.')
        string(name: 'InstanceName', defaultValue: 'wo-dp-mir', description: '')
        string(name: 'VpcId', defaultValue: 'vpc-0d7a53624b6d52e6a', description: '')
        choice(name: 'region', choices: ['us-east-1', 'us-west-2', 'ca-central-1', 'us-east-2', 'us-west-1', 'sa-east-1', 'ap-southeast-1', 'ap-southeast-2', 'ap-southeast-3', 'ap-south-1', 'ap-east-1', 'ap-northeast-1', 'ap-northeast-2', 'ap-northeast-3', 'eu-west-1', 'eu-central-1', 'eu-north-1', 'eu-west-2', 'eu-west-3', 'eu-south-1', 'me-south-1', 'af-south-1'], description: 'Select AWS Region in which cluster needs to be deployed.')
    }

    environment {
        install = "${sh(returnStdout: true, script: '''#!/bin/bash
        curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
        unzip awscliv2.zip
        chmod -R 755 /usr/local/aws-cli/
        ./aws/install
        ''')}"
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        AWS_SESSION_TOKEN = credentials('AWS_SESSION_TOKEN')
        AWS_DEFAULT_REGION = "${region}"
        createUtilStack = "${sh(returnStdout: true, script: "aws cloudformation create-stack --stack-name $InstanceName-util --region $region --template-body file://util-template.yaml --capabilities CAPABILITY_NAMED_IAM --parameters ParameterKey=VPCId,ParameterValue=$VpcId ParameterKey=InstanceName,ParameterValue=$InstanceName | tr -d '\n'")}"
        // utilStackOutput = "${sh(returnStdout: true, script: "aws cloudformation describe-stacks --stack-name $InstanceName-util --region $region  --output json --query 'Stacks[0].Outputs[*]["OutputValue"]' | tr -d '\n'")}"
        subnetIDs = "${sh(returnStdout: true, script: "aws cloudformation describe-stacks --stack-name $InstanceName-util --region $region  --output json --query 'Stacks[0].Outputs[?OutputKey==`GetSubnetIDs`].OutputValue | [0]' | tr -d '\n'")}"
        securityGroupIDs = "${sh(returnStdout: true, script: "aws cloudformation describe-stacks --stack-name $InstanceName-util --region $region  --output json --query 'Stacks[0].Outputs[?OutputKey==`GetSecurityGroupIDs`].OutputValue | [0]' | tr -d '\n'")}"
    // KINESIS_APPLICATION_NAME = "${InstanceName}"
    }

    stages {
        stage('Trigger util cft') {
            steps {
                catchError(buildResult: 'FAILURE', stageResult: 'FAILURE') {
                    sh '''#!/bin/bash
                    echo $AWS_SESSION_TOKEN
                    echo $AWS_ACCESS_KEY_ID
                    echo $AWS_DEFAULT_REGION
                    echo "Subnet ID : $subnetIDs"
                    echo " SecurityGroup ID : $securityGroupID"
                    '''
                }
            }
        }
    }
}
