#!/bin/bash
# Test all collections syntax
echo "Testing all collections syntax..."

# Array of all collections
COLLECTIONS=(
  "node_app_server_bootstrap"
  "dotnet_app_server_bootstrap"
  "php_app_server_bootstrap"
  "python_app_server_bootstrap"
  "golang_app_server_bootstrap"
  "docker_bootstrap"
  "podman_bootstrap"
  "kubernetes_helm_bootstrap"
  "observability_bootstrap"
)

# Function to test a single collection
test_collection() {
  local COLLECTION="$1"
  echo -e "\nTesting $COLLECTION..."
  
  cd "$(dirname "$0")/../$COLLECTION" || return
  
  # Test install playbook
  echo "  - install.yml"
  if ansible-playbook playbooks/install.yml --syntax-check; then
    echo "  ✓ install.yml OK"
  else
    echo "  ✗ install.yml FAILED"
    return 1
  fi
  
  # Test uninstall playbook
  echo "  - uninstall.yml"
  if ansible-playbook playbooks/uninstall.yml --syntax-check; then
    echo "  ✓ uninstall.yml OK"
  else
    echo "  ✗ uninstall.yml FAILED"
    return 1
  fi
  
  echo "  ✓ $COLLECTION OK"
  cd - > /dev/null || return
}

# Test all collections
ALL_OK=0
for COLLECTION in "${COLLECTIONS[@]}"; do
  if ! test_collection "$COLLECTION"; then
    ALL_OK=1
  fi
done

# Summary
if [ $ALL_OK -eq 0 ]; then
  echo -e "\n✅ All collections passed syntax checks!"
else
  echo -e "\n❌ Some collections failed syntax checks!"
  exit 1
fi
