#!/bin/bash -e
# Inspired from https://github.com/facebook/watchman/blob/main/autogen.sh

cd "$(dirname "$0")"

set -x
PREFIX=${PREFIX:-/usr/local}
python3 build/fbcode_builder/getdeps.py fixup-dyn-deps \
        --allow-system-packages \
        --src-dir=. \
        "--project-install-prefix=watchman:$PREFIX" \
        --final-install-prefix "$PREFIX" \
        watchman built

find built -ls