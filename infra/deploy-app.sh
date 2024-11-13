#!/bin/bash

# Default values for the from and to variables
FROM=0
TO=0

PASSWORD=*****
OCP=https://api.cluster-*****.*****.sandbox230.opentlc.com:6443

BROKER=https://raw.githubusercontent.com/stefan-bergstein/serverless-test-app/refs/heads/main/receiver/manifests/broker-trigger.yaml
RECEIVER=https://raw.githubusercontent.com/stefan-bergstein/serverless-test-app/refs/heads/main/receiver/manifests/deployment.yaml
SENDER=https://raw.githubusercontent.com/stefan-bergstein/serverless-test-app/refs/heads/main/sender/manifests/deployment.yaml

# Parse command-line arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --from) FROM="$2"; shift ;;
        --to) TO="$2"; shift ;;
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
done

# Check if FROM and TO are numbers
if ! [[ "$FROM" =~ ^-?[0-9]+$ ]] || ! [[ "$TO" =~ ^-?[0-9]+$ ]]; then
    echo "Error: Both --from and --to options must be integers."
    exit 1
fi

# Loop from FROM to TO and print each number
for (( i=FROM; i<=TO; i++ )); do
    USER="user$i"
    echo "Deploy Borker and App for $USER"
    oc login -u $USER -p $PASSWORD --server=$OCP
    oc apply -f $BROKER
    oc apply -f $RECEIVER
    oc apply -f $SENDER
done
