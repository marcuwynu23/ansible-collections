#!/bin/bash

# Check if collection name is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <collection-name>"
  echo "Available collections:"
  echo "  - node_app_server_bootstrap"
  echo "  - dotnet_app_server_bootstrap"
  echo "  - php_app_server_bootstrap"
  echo "  - python_app_server_bootstrap"
  echo "  - golang_app_server_bootstrap"
  echo "  - docker_bootstrap"
  echo "  - podman_bootstrap"
  echo "  - kubernetes_helm_bootstrap"
  echo "  - observability_bootstrap"
  exit 1
fi

COLLECTION_NAME=$1

# Check if collection directory exists
if [ ! -d "$COLLECTION_NAME" ]; then
  echo "Error: Collection directory '$COLLECTION_NAME' not found!"
  exit 1
fi

# Change to collection directory
cd "$COLLECTION_NAME"

# Build the collection
echo "Building collection..."
ansible-galaxy collection build

# Get the tarball filename
TARBALL=$(ls marcuwynu23-${COLLECTION_NAME}-*.tar.gz 2>/dev/null | head -n 1)

if [ -z "$TARBALL" ]; then
  echo "Error: No collection tarball found!"
  exit 1
fi

# Publish to Ansible Galaxy
echo "Publishing $TARBALL to Ansible Galaxy..."
ansible-galaxy collection publish "$TARBALL"

echo "Done!"
