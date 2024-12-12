#!/bin/bash
# faiss

FAISS_VERSION="1.9.0"
FAISS_BRANCH="v1.9.0"
CUDA_ARCHITECTURES="native"

set -ex
echo "Building faiss ${FAISS_VERSION} (branch=${FAISS_BRANCH})"
    
SRC_DIR=/opt/vectordb/faiss
	
# clone sources
git clone https://github.com/facebookresearch/faiss ${SRC_DIR} && \
cd ${SRC_DIR}
git checkout ${FAISS_BRANCH}

# build C++
install_dir="${SRC_DIR}/install"

mkdir build
cd build

cmake \
  -DBUILD_TESTING=OFF   \
  -DFAISS_ENABLE_GPU=ON \
  -DBUILD_SHARED_LIBS=ON \
  -DFAISS_ENABLE_PYTHON=ON \
  -DFAISS_ENABLE_RAFT=OFF \
  -DCMAKE_CUDA_COMPILER=/usr/local/cuda/bin/nvcc \
  -DPYTHON_EXECUTABLE=/usr/bin/python3 \
  -DCMAKE_CUDA_ARCHITECTURES=${CUDA_ARCHITECTURES} \
  -DCMAKE_INSTALL_PREFIX=${install_dir} \
  ../
  
make -j$(nproc) faiss
make install

# build python
make -j$(nproc) swigfaiss

cd faiss/python
python3 setup.py --verbose bdist_wheel --dist-dir /opt/vectordb

pip3 install --no-cache-dir --verbose /opt/vectordb/faiss*.whl
pip3 show faiss && python3 -c 'import faiss'

# install local copy
cp -r ${install_dir}/* /usr/local/
