#!/bin/bash
# clip_trt
set -ex

SRC_DIR=/opt/vectordb/clip_trt
VERSION_JSON="/tmp/clip_trt_version.json"
CACHE_DIR="$HOME/.cache"
CLIP_MODELS_DIR="/data/models/clip"

curl -o "$VERSION_JSON" "https://api.github.com/repos/dusty-nv/clip_trt/git/refs/heads/main"

git clone https://github.com/dusty-nv/clip_trt "$SRC_DIR" && \
cd "$SRC_DIR" && \
pip3 install --no-cache-dir --verbose -r requirements.txt && \
pip3 install -e . && \
pip3 show clip_trt

mkdir -p "$CACHE_DIR"

python3 -c 'import clip_trt; print("clip_trt imported successfully")' || { echo "Failed to import clip_trt"; exit 1; }