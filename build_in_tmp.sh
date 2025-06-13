#!/bin/bash
set -e

echo "Preparing clean temp build dir..."
sudo rm -rf /tmp/d2ibuild
mkdir -p /tmp/d2ibuild

echo "Copying current repo (excluding ISO files)..."
rsync -a --exclude='*.iso' --exclude='cache' --exclude='chroot' --exclude='.stage' . /tmp/d2ibuild/

echo "Switch to /tmp/d2ibuild"
cd /tmp/d2ibuild

echo "Wiping build leftovers..."
sudo rm -rf cache/ chroot/ config/ auto/ .stage build/ live-build*

echo "Running build.sh from temp location"
./build.sh
