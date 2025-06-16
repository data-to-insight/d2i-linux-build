#!/bin/bash
set -e

mkdir -p output

lb clean --purge || true

lb config \
  --distribution noble \
  --architectures amd64 \
  --debian-installer live \
  --archive-areas main \
  --mirror-bootstrap http://archive.ubuntu.com/ubuntu/ \
  --mirror-chroot http://archive.ubuntu.com/ubuntu/ \
  --mirror-chroot-security http://security.ubuntu.com/ubuntu/ \
  --linux-flavours amd64

mkdir -p config/package-lists config/hooks config/includes.chroot/etc/xdg/xfce4/xfconf/xfce-perchannel-xml

cat <<EOF > config/package-lists/d2i.list.chroot
task-xfce-desktop
firefox
libreoffice
curl
wget
git
EOF

cat <<EOF > config/hooks/0100-wallpaper.chroot
#!/bin/bash
set -e
mkdir -p /usr/share/backgrounds
cp /build/assets/d2i-wallpaper.png /usr/share/backgrounds/d2i-wallpaper.png
EOF

chmod +x config/hooks/0100-wallpaper.chroot

lb build

mv live-image-amd64.hybrid.iso output/d2i-custom.iso
