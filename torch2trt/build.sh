#!/bin/bash
# torch2trt
set -ex

SRC_DIR=/opt/vectordb/torch2trt
PATCHES_DIR="/tmp/patches"
VERSION_JSON="/tmp/torch2trt_version.json"

	
# 下载 torch2trt 版本信息
curl -o "$VERSION_JSON" "https://api.github.com/repos/NVIDIA-AI-IOT/torch2trt/git/refs/heads/master"

mkdir -p "$PATCHES_DIR"
cp -r patches/* "$PATCHES_DIR/"

cd /opt && \
#git clone --depth=1 https://github.com/NVIDIA-AI-IOT/torch2trt "$SRC_DIR"

cp "$PATCHES_DIR/flattener.py" "$SRC_DIR/torch2trt/"

cd "$SRC_DIR" && \
pip3 install --verbose . && \
sed 's|^set(CUDA_ARCHITECTURES.*|#|g' -i CMakeLists.txt && \
sed 's|Catch2_FOUND|False|g' -i CMakeLists.txt && \
cmake -B build -DCMAKE_CUDA_ARCHITECTURES="native" -DCMAKE_CUDA_COMPILER=/usr/local/cuda/bin/nvcc . && \
cmake --build build --target install && \
ldconfig && \
pip3 install --no-cache-dir --verbose nvidia-pyindex && \
pip3 install --no-cache-dir --verbose onnx-graphsurgeon

pip3 show torch2trt
python3 -c 'import torch2trt'

