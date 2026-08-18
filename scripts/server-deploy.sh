#!/bin/bash
set -euo pipefail

# --- Settings ---
USERNAME="lohani01"
REPOSITORY="quick-chat"
VERSION="v1.0"
FULL_IMAGE="$USERNAME/$REPOSITORY:server-$VERSION"
SERVICE_NAME="qc-server"

# --- Connection Details ---
KEY="../secret/docker-mern-key.pem"
EC2_HOST="ec2-user@34.207.49.215"
REMOTE_APP_DIR="~/quick-chat"

# --- Deploy to EC2 ---
echo "Deploying $FULL_IMAGE to $EC2_HOST ..."

ssh -o StrictHostKeyChecking=accept-new -i "$KEY" "$EC2_HOST" "
  cd $REMOTE_APP_DIR
  docker compose pull $SERVICE_NAME
  docker compose up -d --no-deps $SERVICE_NAME
"

echo "Server deployment complete. API listening internally on port 5050."
