oc project rhsc-hands-on 
oc delete -f manifests/deployment.yaml
podman build -t receiver:latest -f Containerfile . 
podman tag receiver:latest quay.io/knative-coding-challange/receiver:latest
podman push quay.io/knative-coding-challange/receiver:latest
oc apply -f manifests/deployment.yaml 