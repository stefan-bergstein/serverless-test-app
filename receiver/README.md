
# Build and push the receiver image
```
podman build -t receiver:latest -f Containerfile .
podman tag receiver:latest quay.io/knative-coding-challange/receiver:latest
podman push quay.io/knative-coding-challange/receiver:latest
```

# Run the receiver locally
```
podman run -it --rm --name receiver -p 8080:8080 receiver:latest
```