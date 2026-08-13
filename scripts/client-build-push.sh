#!/bin/bash
set -euo pipefail

# Verify docker buildx is available
if ! docker buildx version &> /dev/null; then
    echo "Error: docker buildx is required but not installed"
    exit 1
fi

# Verify Docker authentication
if ! docker info &> /dev/null; then
    echo "Error: Not authenticated to Docker. Run 'docker login' first"
    exit 1
fi

USERNAME="lohani01"
REPOSITORY="quick-chat"
VERSION="v1.0"
CLIENT_IMAGE="$USERNAME/$REPOSITORY:client-$VERSION"

docker buildx create --use 2>/dev/null || true

echo "Building and pushing $CLIENT_IMAGE for AMD64/ARM64..."
docker buildx build --platform linux/amd64,linux/arm64 -t "$CLIENT_IMAGE" ../client --push

echo "Done. Client multi-arch image is live on Docker Hub."
