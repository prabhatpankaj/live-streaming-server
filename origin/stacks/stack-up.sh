#!/bin/bash

PROFILE="--profile witty"
domain=wittychamps.com
subdomain=live.wittychamps.com

case $1 in
    ecr)
        aws cloudformation deploy \
        --template-file ecr.stack.yml \
        --stack-name video-streaming-origin-ecr \
        --capabilities CAPABILITY_IAM \
        --parameter-overrides \
        RepositoryName=video-streaming-origin \
        ${PROFILE}
        ;;
    service)
        SSLArn=$(aws acm list-certificates --certificate-statuses ISSUED ${PROFILE} --query "CertificateSummaryList[?DomainName=='${domain}'][CertificateArn]" --output text)
        account=$(aws sts get-caller-identity ${PROFILE} --query "Account" --output text)
        sed -i -e "s/132093761664/$account/g" ../package.json
        sed -i -e "s|--profile bluefin|$PROFILE|g" ../package.json
        yarn run deploy
        aws cloudformation deploy \
        --template-file service.stack.yml \
        --stack-name video-streaming-origin \
        --capabilities CAPABILITY_NAMED_IAM \
        --parameter-overrides \
        Version=1.0.0 \
        DesiredCount=1 \
        TLD=${domain} \
        Domain=${subdomain} \
        SSLArn=${SSLArn} \
        ${PROFILE}
        ;;
    *)
        echo $"Usage: $0 {ecr|service-}"
        exit 1
esac