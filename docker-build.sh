#!/bin/bash
# docker-build.sh

# Build the image
echo "Building Docker image..."
docker build -t opencv-cuda-13.02-dev .

echo Done!