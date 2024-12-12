#!/bin/bash
# faiss_lite
set -ex

SRC_DIR=/opt/vectordb/faiss_lite
mkdir ${SRC_DIR}
cp CMakeLists.txt faiss_lite.cu test.cu faiss_lite.py benchmark.py ${SRC_DIR}

mkdir ${SRC_DIR}/build && \
    cd ${SRC_DIR}/build && \
    cmake \
	-DCMAKE_CUDA_ARCHITECTURES="native" \
	-DCMAKE_CUDA_COMPILER=/usr/local/cuda/bin/nvcc \
	../ && \
    make
	
echo "export PYTHONPATH=\${PYTHONPATH}:${SRC_DIR}" >> ~/.bashrc && source ~/.bashrc