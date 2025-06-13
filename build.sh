#!/bin/bash
set -e

# Clean previous attempts
rm -rf config/ auto/ cache/ chroot/ .stage

# Basic config
lb config \
  --distribution noble \
  --architectures amd64 \
  --linux-flavours amd64 \
  --debian-installer live \
  --archive-areas "main" \
  --mirror-bootstrap http://archive.ubuntu.com/ubuntu/ \
  --mirror-chroot http://archive.ubuntu.com/ubuntu/ \
  --mirror-chroot-security http://security.ubuntu.com/ubuntu/

# Add basic packages
mkdir -p config/package-lists
cat <<EOF > config/package-lists/base.list.chroot
task-xfce-desktop
firefox
curl
EOF

# Build ISO
lb build
