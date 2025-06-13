#!/bin/bash
# chmod +x build_in_tmp.sh

set -e

echo "Copy proj to /tmp/d2ibuild..."
sudo rm -rf /tmp/d2ibuild
mkdir -p /tmp/d2ibuild
rsync -a --exclude='*.iso' . /tmp/d2ibuild/

echo "Change to /tmp/d2ibuild"
cd /tmp/d2ibuild

echo "Run build script"
sudo ./build.sh

echo "complete: ISO located at /tmp/d2ibuild/live-image-amd64.hybrid.iso"
