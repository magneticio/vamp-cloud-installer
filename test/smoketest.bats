set -eu

# Vamp installer smoke-test.
#
# Uses a fake `kubectl` command

_fake_kubectl=./test-scripts/kubectl
if [ ! -f "${_fake_kubectl}" ]; then
  echo "Required support script ${_fake_kubectl} wasn't found. This script is used to fake kubectl in tests to prevent accidental modifying of real Kubernetes clusters, so tests will refuse to run without it."
  exit 1
fi

setup() {
  PATH="./test-scripts/:${PATH}"
}

@test "a successful install exits zero" {
  sh install.sh
  local status=$?
  [ "$status" -eq 0 ]
}

@test "an unsuccessful install exits nonzero" {
  set +e
  sh install.sh fail
  local status=$?
  set -e
  [ "$status" -ne 0 ]
}
