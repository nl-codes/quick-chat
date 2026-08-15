#!/bin/bash
set -euo pipefail

# Verify docker buildx is available
if ! docker buildx version &> /dev/null; then
    echo "Error: docker buildx is required but not installed"
    exit 1
fi

# log in without a prompt, using the token piped in
echo "$DOCKERHUB_TOKEN" | docker login -u "$DOCKERHUB_USERNAME" --password-stdin

# Verify Docker authentication
if ! docker info &> /dev/null; then
    echo "Error: Not authenticated to Docker. Run 'docker login' first"
    exit 1
fi


TAG="$SUB_REPOSITORY-$VERSION"
IMAGE_NAME="$DOCKERHUB_USERNAME/$REPOSITORY:$TAG"

docker buildx create --use 2>/dev/null || true

echo "Building and pushing $IMAGE_NAME for AMD64/ARM64..."
docker buildx build --platform linux/amd64,linux/arm64 -t "$IMAGE_NAME" ./"$SUB_REPOSITORY" --push

echo "Done. $SUB_REPOSITORY multi-arch image is live on Docker Hub."
