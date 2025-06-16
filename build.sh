#!/bin/bash
set -e

mkdir -p output

lb clean --purge || true

sudo lb config \
  --distribution noble \
  --architectures amd64 \
  --debian-installer live \
  --archive-areas main \
  --mirror-bootstrap http://archive.ubuntu.com/ubuntu/ \
  --mirror-chroot http://archive.ubuntu.com/ubuntu/ \
  --mirror-chroot-security http://security.ubuntu.com/ubuntu/ \
  --linux-flavours amd64 \
  --chroot false


mkdir -p config/package-lists config/hooks config/includes.chroot/etc/xdg/xfce4/xfconf/xfce-perchannel-xml

cat <<EOF > config/package-lists/d2i.list.chroot
task-xfce-desktop
firefox
libreoffice
curl
wget
git
EOF

mkdir -p config/hooks

cat <<EOF > config/hooks/0100-wallpaper.binary
#!/bin/bash
set -e
mkdir -p /usr/share/backgrounds
cp /build/assets/d2i-wallpaper.png /usr/share/backgrounds/d2i-wallpaper.png || echo "Wallpaper not found, skipping"
EOF

chmod +x config/hooks/0100-wallpaper.binary


lb build

mv live-image-amd64.hybrid.iso output/d2i-custom.iso
