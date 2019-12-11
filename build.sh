#!/bin/bash

if [ "$#" == "0" ]; then
    echo -e 'Usage:\nbuild.sh [--deploy arn:aws:sns:...] [--down]'
    exit 0
fi

function confirm {
    while true; do
        read -r -p "Confirm ${1}: [y/n] " answer
        case $answer in
            [Nn]* ) return 1;;
            [Yy]* ) break;;
            *     ) echo 'Please answer yes or no';;
        esac
    done
}

case "$1" in
    --deploy)
        ACTION='deploy'
        if [ -z "$2" ]; then
            echo 'error: missing SNS arn' >&2
            exit 1
        fi
        SNSTOPIC="$2"
        shift 2
        ;;
    --down)
        ACTION='down'
        shift
        ;;
    -*|--*)
        echo "Error: unsupported flag $1" >&2
        exit 1
        ;;
    *)
        echo "Error: unsupported parameter $1" >&2
        exit 1
        ;;
esac

PROJNAME=$(basename "$(pwd | tr -d [:space:])")

if [ "$ACTION" == 'deploy' ]; then
    aws cloudformation deploy \
        --stack-name $PROJNAME \
        --template-file ecs-problem-event-rules.yaml \
        --no-fail-on-empty-changeset \
        --parameter-overrides "SnsTopicNotify=${SNSTOPIC}"

elif [ "$ACTION" == 'down' ]; then
    if ! confirm "delete all resources within and the stack itself '${PROJNAME}'"; then
        exit 1
    fi
    aws cloudformation delete-stack \
        --stack-name $PROJNAME \

fi
