#!/bin/bash
# nonaDB
set -ex

SRC_DIR=/opt/vectordb/NanoDB
VERSION_JSON="/tmp/nanodb_version.json"

curl -o "$VERSION_JSON" "https://api.github.com/repos/dusty-nv/nanodb/git/refs/heads/main"

git clone https://github.com/dusty-nv/NanoDB ${SRC_DIR} && \
    cd ${SRC_DIR} && \
    pip3 install --ignore-installed --no-cache-dir blinker && \
    pip3 install --no-cache-dir --verbose -r requirements.txt && \
    pip3 install --user -e .

