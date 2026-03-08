# Makefile for test_opencv_cuda

CXX      := g++
CXXFLAGS := -std=c++23 -O2
TARGET   := test_opencv_cuda
SRCDIR   := src
SRCS     := $(SRCDIR)/test_opencv_cuda.cpp
OUTDIR   := build

# OpenCV flags via pkg-config
OPENCV_CFLAGS := $(shell pkg-config --cflags opencv4)
OPENCV_LIBS   := $(shell pkg-config --libs opencv4)

# CUDA
CUDA_INC  := -I/usr/local/cuda/include
CUDA_LIBS := -L/usr/local/cuda/lib64 -lcudart

CFLAGS_ALL := $(CXXFLAGS) $(OPENCV_CFLAGS) $(CUDA_INC)
LIBS_ALL   := $(OPENCV_LIBS) $(CUDA_LIBS)

.PHONY: all clean

all: $(TARGET)

$(TARGET): $(SRCS)
	mkdir -p $(OUTDIR)
	$(CXX) $(CFLAGS_ALL) -o $(OUTDIR)/$(TARGET) $^ $(LIBS_ALL)

run:
	cd $(OUTDIR) && ./$(TARGET)

clean:
	mkdir -p $(OUTDIR)
	rm -fr $(OUTDIR)/*