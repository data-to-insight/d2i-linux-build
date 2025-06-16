#!/bin/bash
set -e

mkdir -p output

# (hard)cleanup
rm -rf auto config cache chroot .build .stage live-image* output/*

# Re-config build with chroot disabled
lb config \
  --distribution noble \
  --architectures amd64 \
  --debian-installer live \
  --archive-areas main \
  --mirror-bootstrap http://archive.ubuntu.com/ubuntu/ \
  --mirror-chroot http://archive.ubuntu.com/ubuntu/ \
  --mirror-chroot-security http://security.ubuntu.com/ubuntu/ \
  --linux-flavours amd64 \
  --chroot false

# Force override in case lb config didn't persist --chroot=false
echo "LB_CHROOT=false" > auto/config

# Package list
mkdir -p config/package-lists
cat <<EOF > config/package-lists/d2i.list.chroot
task-xfce-desktop
firefox
libreoffice
curl
wget
git
EOF

# Binary (non-chroot) hook
mkdir -p config/hooks
cat <<EOF > config/hooks/0100-wallpaper.binary
#!/bin/bash
set -e
mkdir -p /usr/share/backgrounds
cp /build/assets/d2i-wallpaper.png /usr/share/backgrounds/d2i-wallpaper.png || echo "Wallpaper not found, skipping"
EOF

chmod +x config/hooks/0100-wallpaper.binary

# force disable priv chroot stages
# Disable all chroot operations completely
echo "LB_CHROOT=false" >> auto/config
echo "LB_CHROOT_DEVPTS=no" >> auto/config
echo "LB_CHROOT_PROC=no" >> auto/config
echo "LB_CHROOT_SYSFS=no" >> auto/config

# build iso (non-chrooted)
lb build

# iso to output
mv live-image-amd64.hybrid.iso output/d2i-custom.iso


mv live-image-amd64.hybrid.iso output/d2i-custom.iso
