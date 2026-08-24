#!/bin/bash
set -euo pipefail

# --- Settings ---
FRONTEND_DIR="client"
# S3_BUCKET="s3://quick-chat-s3-bucket" # passed from env
S3_BUCKET="${S3_BUCKET:-s3://quick-chat-s3-bucket}"

echo "0. Change directory to frontend"
cd "$FRONTEND_DIR"

echo "1. Building React static assets..."
npm run build

echo "2. Uploading dist/ folder to S3..."
# --delete ensures deleted local files are removed from the bucket
aws s3 sync dist/ "$S3_BUCKET" --delete

# Clean up s3:// prefix for printing website URL
CLEAN_BUCKET_NAME="${S3_BUCKET#s3://}"

echo "----------------------------------------"
echo "Frontend deployment to S3 complete!"
echo "Website URL: http://${CLEAN_BUCKET_NAME}.s3-website-us-east-1.amazonaws.com/"
echo "----------------------------------------"
