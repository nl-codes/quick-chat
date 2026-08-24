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
echo "Deploying load-balanced backend stack with $IMAGE_NAME to $EC2_USER@$EC2_HOST ..."

# Ensure destination structure exists
ssh -o StrictHostKeyChecking=accept-new -i key.pem "$EC2_USER@$EC2_HOST" "mkdir -p $REMOTE_APP_DIR/server"

# Sync runtime compose and nginx config used by EC2
scp -o StrictHostKeyChecking=accept-new -i key.pem docker-compose.yml "$EC2_USER@$EC2_HOST:$REMOTE_APP_DIR/docker-compose.yml"
scp -o StrictHostKeyChecking=accept-new -i key.pem server/nginx-ec2.conf "$EC2_USER@$EC2_HOST:$REMOTE_APP_DIR/server/nginx-ec2.conf"

ssh -o StrictHostKeyChecking=accept-new -i key.pem "$EC2_USER@$EC2_HOST" "
  cd $REMOTE_APP_DIR
  export DOCKERHUB_USERNAME=$DOCKERHUB_USERNAME
  export VERSION=$VERSION
  docker compose pull nginx qc-api1 qc-api2 qc-api3
  docker compose up -d --remove-orphans
"

rm -f key.pem

echo "Server deployment complete. Nginx is live on port 80 with qc-api replicas behind it."
