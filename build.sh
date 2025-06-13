# build.sh
set -e

# Update host packages
sudo apt update
sudo apt install -y live-build wget curl

# Clean up any previous build
sudo lb clean --purge || true
sudo rm -rf config auto cache chroot binary

# Ubuntu-specific config
sudo lb config \
  --distribution focal \
  --architectures amd64 \
  --linux-flavours generic \
  --mirror-bootstrap http://archive.ubuntu.com/ubuntu/ \
  --mirror-chroot-security http://security.ubuntu.com/ubuntu/ \
  --debian-installer live \
  --archive-areas "main restricted universe multiverse"

# Add custom packages and hooks
mkdir -p config/package-lists config/hooks

cat <<EOF > config/package-lists/custom.list.chroot
task-xfce-desktop
firefox
libreoffice
curl
wget
git
thunderbird
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

# Final build command
sudo lb build
