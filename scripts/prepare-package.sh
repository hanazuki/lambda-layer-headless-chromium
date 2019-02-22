#!/bin/bash
set -euxo pipefail

sudo apt update -qq
sudo apt -y install binutils fontconfig fonts-noto-cjk zip
sudo snap install docker
