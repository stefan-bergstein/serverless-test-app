check_return_code() {
  if [[ $1 == 0 ]]; then
      echo "✅ "
  else
      echo "💥 ERROR!"
      exit
  fi  
}

# --- Check cli -----------------------------------------------------
echo -n "Check oc cli "
which oc >/dev/null 2>&1
check_return_code $?


# --- VARS -----------------------------------------------------
source install_cleanup_vars.sh


# --- OpenShift Serverless Operator-----------------------------------------------------
if [[ "$INST_KNATIVE" == true ]]; then

  KNATIVE_INSTALLED=$(oc get csv -n openshift-operators | grep serverless)
  if [[ $KNATIVE_INSTALLED == *"Succeeded"* ]]; then
    echo "✅ OpenShift Serverless Operator"
  else
    echo "-> Installing OpenShift Serverless Operator..."

    read -r -d '' YAML_CONTENT <<EOF
---
apiVersion: v1
kind: Namespace
metadata:
  name: openshift-serverless
---
apiVersion: operators.coreos.com/v1
kind: OperatorGroup
metadata:
  name: serverless-operators
  namespace: openshift-serverless
spec: {}
---
apiVersion: operators.coreos.com/v1alpha1
kind: Subscription
metadata:
  name: serverless-operator
  namespace: openshift-serverless
spec:
  channel: stable 
  name: serverless-operator 
  source: redhat-operators 
  sourceNamespace: openshift-marketplace 
EOF
    echo "$YAML_CONTENT" | oc apply -f -
    sleep 60
    oc wait --for=condition=initialized --timeout=60s pods -l name=knative-openshift -n openshift-serverless
  fi

fi

# --- OpenShift Serverless Setup -----------------------------------------------------
if [[ "$CONF_KNATIVE" == true ]]; then
  echo "Configure OpenShift Serverless..."
  oc apply -f knative-eventing.yaml
fi



