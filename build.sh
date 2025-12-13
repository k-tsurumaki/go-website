#!/bin/bash

# Lambda用にビルド
GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -o bootstrap main.go

# zipファイルを作成
if command -v zip &> /dev/null; then
    zip lambda-deployment.zip bootstrap templates
elif command -v python3 &> /dev/null; then
    python3 -m zipfile -c lambda-deployment.zip bootstrap templates
else
    echo "Error: zip or python3 is required to create deployment package"
    exit 1
fi

echo "Build complete! Deploy lambda-deployment.zip to AWS Lambda"
