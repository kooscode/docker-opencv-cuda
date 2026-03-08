# Dockerfile
FROM nvidia/cuda:13.0.2-cudnn-devel-ubuntu24.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC

RUN apt update -y 
RUN apt upgrade -y 

# Generic tools
RUN apt install build-essential cmake pkg-config unzip yasm git checkinstall -y 

# Image I/O libs
RUN apt install libjpeg-dev libpng-dev libtiff-dev -y 

# Video/Audio Libs - FFMPEG, GSTREAMER, x264, and etc
# Install basic codec libraries
RUN apt install libavcodec-dev libavformat-dev libavutil-dev libswscale-dev -y 
# Install GStreamer development libraries
RUN apt install libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev -y 
# Install additional codec and format libraries
RUN apt install libxvidcore-dev libx264-dev libmp3lame-dev libopus-dev -y 
# Install additional audio codec libraries
RUN apt install libmp3lame-dev libvorbis-dev -y 
# Install FFmpeg (which includes libavresample functionality)
RUN apt install ffmpeg -y 
# Optional: Install VA-API for hardware acceleration
RUN apt install libva-dev -y 

# Cameras programming interface libs
# Install video capture libraries and utilities
RUN apt install libdc1394-25 libdc1394-dev libxine2-dev libv4l-dev v4l-utils -y 
# Create a symbolic link for video device header
RUN ln -s /usr/include/libv4l1-videodev.h /usr/include/linux/videodev.h

# GTK lib for the graphical user functionalites coming from OpenCV highghui module
RUN apt-get install libgtk-3-dev -y 

# Parallelism library C++ for CPU
RUN apt-get install libtbbmalloc2 libtbb-dev -y 

# Optimization libraries for OpenCV
RUN apt-get install libatlas-base-dev gfortran -y 

# Install additional tools for development
RUN apt-get update && apt-get install -y \
    vim \
    nano \
    gdb \
    && rm -rf /var/lib/apt/lists/*

# Install LATEST OpenCV with CUDA support (using OpenCV compatible with CUDA)
RUN cd /tmp && \
    git clone https://github.com/opencv/opencv.git && \
    git clone https://github.com/opencv/opencv_contrib.git && \
    cd opencv && \
    mkdir build && \
    cd build && \
    cmake .. \
        -D CMAKE_BUILD_TYPE=Release \
        -D CMAKE_INSTALL_PREFIX=/usr/local \
        -D OPENCV_EXTRA_MODULES_PATH=../../opencv_contrib/modules \
        -D WITH_CUDA=ON \
        -D CUDA_ARCH_BIN="8.9" \
        -D BUILD_opencv_cudacodec=ON \
        -D WITH_CUDNN=ON \
        -D ENABLE_FAST_MATH=1 \
        -D CUDA_FAST_MATH=1 \
        -D WITH_CUBLAS=1 \
        -D BUILD_opencv_python3=OFF \
        -D BUILD_opencv_python2=OFF \
        -D BUILD_TESTS=OFF \
        -D BUILD_PERF_TESTS=OFF \
        -D BUILD_EXAMPLES=OFF \
        -D OPENCV_GENERATE_PKGCONFIG=ON \
        -DCMAKE_LIBRARY_PATH=/usr/local/cuda/lib64/stubs  \       
        .. && \
    make -j$(nproc) && \
    make install && \
    ldconfig && \
    rm -rf /tmp/opencv* && \
    rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app