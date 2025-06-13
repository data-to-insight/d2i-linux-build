#!/bin/bash
set -e

sudo apt update
sudo apt install -y live-build wget curl

sudo lb clean --purge
sudo rm -rf config auto

sudo /usr/bin/lb clean --purge
sudo /usr/bin/lb config \
  --distribution bookworm \
  --architectures amd64 \
  --linux-flavours amd64 \
  --mirror-bootstrap http://deb.debian.org/debian/ \
  --mirror-chroot-security http://security.debian.org/ \
  --debian-installer live \
  --archive-areas "main" \
  --bootstrap include=debian-archive-keyring
sudo /usr/bin/lb build



mkdir -p config/package-lists config/hooks

cat <<EOF > config/package-lists/custom.list.chroot
task-xfce-desktop
firefox-esr
libreoffice
curl
wget
git
EOF

cat <<EOF > config/hooks/0100-anaconda.chroot
#!/bin/bash
set -e
cd /tmp
wget https://repo.anaconda.com/archive/Anaconda3-2024.02-1-Linux-x86_64.sh
bash Anaconda3-2024.02-1-Linux-x86_64.sh -b -p /opt/anaconda
echo 'export PATH=/opt/anaconda/bin:\$PATH' >> /etc/profile.d/anaconda.sh
EOF

chmod +x config/hooks/0100-anaconda.chroot

sudo lb build
