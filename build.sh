#!/bin/bash
set -e

# ensure working in project root
cd "$(dirname "$0")/.."

mkdir -p output

# clean any previous build safely
lb clean --purge || true

# configure build
lb config \
  --distribution noble \
  --architectures amd64 \
  --debian-installer live \
  --archive-areas main \
  --mirror-bootstrap http://archive.ubuntu.com/ubuntu/ \
  --mirror-chroot http://archive.ubuntu.com/ubuntu/ \
  --mirror-chroot-security http://security.ubuntu.com/ubuntu/ \
  --linux-flavours amd64

# package lists and hooks
mkdir -p config/package-lists \
         config/hooks \
         config/includes.chroot/etc/xdg/xfce4/xfconf/xfce-perchannel-xml

# main packages
cat <<EOF > config/package-lists/d2i.list.chroot
task-xfce-desktop
firefox
libreoffice
curl
wget
git
EOF

# wallpaper hook
cat <<'EOF' > config/hooks/0100-wallpaper.chroot
#!/bin/bash
set -e
mkdir -p /usr/share/backgrounds
cp /build/assets/d2i-wallpaper.png /usr/share/backgrounds/d2i-wallpaper.png
EOF

chmod +x config/hooks/0100-wallpaper.chroot

# build the ISO
lb build

# move ISO to output
mv live-image-amd64.hybrid.iso output/d2i-custom.iso
