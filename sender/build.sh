oc project rhsc-hands-on 
oc delete -f manifests/deployment.yaml
podman build -t sender:latest -f Containerfile . 
podman tag sender:latest quay.io/knative-coding-challange/sender:latest
podman push quay.io/knative-coding-challange/sender:latest
oc apply -f manifests/deployment.yaml 