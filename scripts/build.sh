#!/bin/bash
set -euxo pipefail

export PATH="$PATH:$PWD/depot_tools"

cd ~/chromium/src

if [[ -n ${CR_VERSION:-} ]]; then
    git fetch --depth=1 origin tag "${CR_VERSION}"
    git checkout tags/"${CR_VERSION}"
else
    git fetch --depth=1 origin master
    git checkout origin/master
fi

gclient sync -v --with_branch_heads --with_tags

gn gen out/Headless
autoninja -C out/Headless headless_shell chromedriver

mkdir -p ~/out
cd out/Headless

cp -r -t ~/out ./headless_shell ./swiftshader ./chromedriver
