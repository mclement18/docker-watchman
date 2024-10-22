#!/bin/bash -e
# Inspired from https://github.com/facebook/watchman/blob/main/autogen.sh

cd "$(dirname "$0")"

set -x
PREFIX=${PREFIX:-/usr/local}
python3 build/fbcode_builder/getdeps.py build \
        --allow-system-packages \
        --no-deps \
        --src-dir=. \
        "--project-install-prefix=watchman:$PREFIX" \
        watchman
