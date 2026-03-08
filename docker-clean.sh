#!/bin/bash
# docker-build.sh

# Build the image
echo "Cleaning Docker image..."
docker rmi -f opencv-cuda-13.02-dev 2>/dev/null || true

#optional nuclear option to also clear builder cache to force image rebuild.
# *** WARNING USE WITH CAUTION!!  WILL CLEAR OUT ALL DOCKER ARTIFACTS FOR ANY INACTIVE CONTAINERS !!
#docker system prune --all --volumes

echo Done!