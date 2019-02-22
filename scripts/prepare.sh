#!/bin/bash
set -euxo pipefail

sudo apt-get update -q
sudo apt-get install -y awscli git python default-jdk-headless fonts-noto-cjk

cd

git clone --depth=1 https://chromium.googlesource.com/chromium/tools/depot_tools.git
export PATH="$PATH:$PWD/depot_tools"

mkdir -p chromium
cd chromium

fetch --nohooks chromium
cd src
./build/install-build-deps.sh --no-arm --no-nacl

gclient sync -v --with_branch_heads --with_tags
