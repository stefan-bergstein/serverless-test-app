# OpenShift Serverless - Duplicate Cloud Events 

Your team is working on a Serverless app and has created an initial test app for sending Cloud Events from a sender pod to a receiver pod. 

The app is to be deployed on OpenShift and then presented to the other teams and the product owner in the Sprint Review. 
The sender pod sends test messages every 10 sends. Unfortunately, the receiver pod receives a lot of duplicate messages.

The app is already on GitHub in the following repo:
https://github.com/stefan-bergstein/serverless-test-app

Required manifests to deploy the application:
1. Broker and Trigger: [receiver/manifests/broker-trigger.yaml](receiver/manifests/broker-trigger.yaml)
2. Receiver: [receiver/manifests/deployment.yaml](receiver/manifests/deployment.yaml)
3. Sender: [sender/manifests/deployment.yaml](sender/manifests/deployment.yaml)

Use the manifests to deploy the app on OpenShift, find out why the receiver receives a lot of duplicate messages, describe the root cause. 
The duplicate messages are visible in the logs of the receiver pod. E.g.,
```
Received event: b' {"message": "20.10.2024, 13:47:32: This is a cloud event."}'
Received event: b' {"message": "20.10.2024, 13:47:32: This is a cloud event."}'
Received event: b' {"message": "20.10.2024, 13:47:32: This is a cloud event."}'
Received event: b' {"message": "20.10.2024, 13:47:32: This is a cloud event."}'
Received event: b' {"message": "20.10.2024, 13:47:32: This is a cloud event."}'
```

Then submit the challenge and write in the comment text field what the problem was and propose steps to fix it. If you solve it correctly, you get the points!


## Prerequisites

- OpenShift Serverless. See [infra/install.sh](infra/install.sh)