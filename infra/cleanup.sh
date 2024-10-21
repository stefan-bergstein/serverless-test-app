# --- VARS -----------------------------------------------------
source install_cleanup_vars.sh

# --- OpenShift Serverless Setup -----------------------------------------------------
if [[ "$CONF_KNATIVE" == true ]]; then
    echo "Delete OpenShift Serverless Setup..."
    oc delete -f knative-eventing.yaml
fi
