#!/bin/bash
set -e

mkdir -p output

lb clean --purge || true

lb config \
  --distribution noble \
  --architectures amd64 \
  --mode debian \
  --system live \
  --debian-installer live \
  --archive-areas main \
  --mirror-bootstrap http://archive.ubuntu.com/ubuntu/ \
  --mirror-chroot http://archive.ubuntu.com/ubuntu/ \
  --mirror-chroot-security http://security.ubuntu.com/ubuntu/ \
  --linux-flavours amd64 \
  --chroot false

mkdir -p config/package-lists
cat <<EOF > config/package-lists/d2i.list.chroot
task-xfce-desktop
firefox
libreoffice
curl
wget
git
zenity
thunderbird
element-desktop
slack-desktop  # Installed via hook
network-manager-openvpn
network-manager-openvpn-gnome
EOF
