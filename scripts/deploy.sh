#!/bin/bash
set -euo pipefail

# --- Settings ---
TAG="$SUB_REPOSITORY-$VERSION"
IMAGE_NAME="$DOCKERHUB_USERNAME/$REPOSITORY:$TAG"

REMOTE_APP_DIR="~/quick-chat"

# write the key from the environment to a temp file, lock it down
echo "$EC2_SSH_KEY" > key.pem
chmod 400 key.pem

# --- Deploy to EC2 ---
echo "Deploying $IMAGE_NAME to $EC2_USER@$EC2_HOST ..."

ssh -o StrictHostKeyChecking=accept-new -i key.pem "$EC2_USER@$EC2_HOST" "
  cd $REMOTE_APP_DIR
  docker compose pull $SERVICE_NAME
  docker compose up -d --no-deps $SERVICE_NAME
"

rm -f key.pem

echo "Server deployment complete. API IS LIVE at its port"
