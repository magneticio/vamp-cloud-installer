#!/bin/sh

set -eu

VAMP_INSTALLER_VERSION=3.0.5
VAMP_INSTALLER_IMAGE=${DEFAULT_VAMP_INSTALLER_IMAGE:=vampio/k8s-installer:$VAMP_INSTALLER_VERSION}
VAMP_INSTALLER_BOOTSTRAP_YAML=${DEFAULT_VAMP_BOOTSTRAP_YAML:=https://raw.githubusercontent.com/magneticio/vamp-cloud-installer/master/bootstrap-policy.yaml}

# A shell script can only have a single trap set for each signal, including the
# EXIT pseudosignal. All cleanup needs to be handled by this function.
cleanup() {
  kubectl delete -f "$VAMP_INSTALLER_BOOTSTRAP_YAML" || true
  kubectl delete pod vamp-cloud-installer || true
}

trap cleanup EXIT

echo "Vamp Cloud Installer: $VAMP_INSTALLER_VERSION"

# Apply policy required to be able to create the resources.
kubectl apply -f "$VAMP_INSTALLER_BOOTSTRAP_YAML"

# Run nats-setup container containing the latest set of manifests.
kubectl run vamp-cloud-installer --image-pull-policy=Always --serviceaccount=vamp-cloud-installer --image=$VAMP_INSTALLER_IMAGE --restart=Never

# Wait for the setup container to start or bail.
kubectl wait --for=condition=Ready pod/vamp-cloud-installer --timeout=30s

# Pass the custom parameters to the nats-setup container image.
kubectl exec vamp-cloud-installer -- vamp-installer.sh -v "$VAMP_INSTALLER_VERSION" "$@"
