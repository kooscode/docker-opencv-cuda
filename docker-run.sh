#!/bin/bash
# docker-run.sh

# Allow Docker containers to connect to the host X server
xhost +local:docker

# Run container with proper volume mounting and GPU access
echo "Starting development container..."
docker run --gpus all --net=host --ipc=host \
    --privileged \
    -v /dev:/dev \
    -e DISPLAY=$DISPLAY \
    -e XAUTHORITY=$XAUTHORITY \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v $HOME/.Xauthority:/root/.Xauthority:ro \
    -v $(pwd):/app \
    -it opencv-cuda-13.02-dev /bin/bash

# Revoke the permission when done (optional, for security)
xhost -local:docker
