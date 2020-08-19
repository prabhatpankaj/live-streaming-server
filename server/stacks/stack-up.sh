#!/bin/bash

PROFILE="--profile witty"

case $1 in
    ecr)
        aws cloudformation deploy \
        --template-file ecr.stack.yml \
        --stack-name video-streaming-server-ecr \
        --capabilities CAPABILITY_IAM \
        --parameter-overrides \
        RepositoryName=video-streaming-server \
        ${PROFILE}
        ;;
    service)
        account=$(aws sts get-caller-identity ${PROFILE} --query "Account" --output text)
        sed -i -e "s/132093761664/$account/g" ../package.json
        sed -i -e "s|--profile bluefin|$PROFILE|g" ../package.json
        yarn run deploy
        aws cloudformation deploy \
        --template-file service.stack.yml \
        --stack-name video-streaming-server \
        --capabilities CAPABILITY_NAMED_IAM \
        --parameter-overrides \
        Version=1.0.15 \
        DesiredCount=1 \
        RedisStack=video-streaming-redis \
        ${PROFILE}
        ;;
    *)
        echo $"Usage: $0 {ecr|service-}"
        exit 1
esac