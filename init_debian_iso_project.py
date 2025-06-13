
# chmod +x build.sh config/hooks/0100-anaconda.chroot
# sudo ./build.sh
import os

def write_file(path, content):
    dir_path = os.path.dirname(path)
    if dir_path:
        os.makedirs(dir_path, exist_ok=True)
    with open(path, "w", encoding="utf-8") as f:
        f.write(content)

files = {
    ".github/workflows/build.yml": """\
name: Build Debian ISO with GUI

on:
  push:
    branches: [main]

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v4

      - name: Install dependencies
        run: |
          sudo apt update
          sudo apt install -y live-build wget curl

      - name: Build ISO
        run: |
          sudo lb clean
          sudo lb config
          sudo lb build

      - name: Upload ISO
        uses: actions/upload-artifact@v4
        with:
          name: debian-custom-iso
          path: ./live-image-amd64.hybrid.iso
""",

    "config/package-lists/custom.list.chroot": """\
task-xfce-desktop
firefox-esr
libreoffice
curl
wget
git
""",

    "config/hooks/0100-anaconda.chroot": """\
#!/bin/bash
set -e
cd /tmp

wget https://repo.anaconda.com/archive/Anaconda3-2024.02-1-Linux-x86_64.sh
bash Anaconda3-2024.02-1-Linux-x86_64.sh -b -p /opt/anaconda
echo 'export PATH=/opt/anaconda/bin:$PATH' >> /etc/profile.d/anaconda.sh
""",

    "build.sh": """\
#!/bin/bash
set -e
sudo apt update
sudo apt install -y live-build wget curl
lb clean
lb config
sudo lb build
""",

    "README.md": '''\
# Debian Custom ISO with GUI and Tools

## Includes:
- XFCE Desktop
- Firefox browser
- LibreOffice (Excel-compatible)
- Anaconda Python (installed to /opt/anaconda)

## Local Build (inside Codespace or Debian VM)

    chmod +x build.sh config/hooks/0100-anaconda.chroot
    sudo ./build.sh

## GitHub Actions
On push to main, builds ISO and uploads as an artifact.
'''
}

for path, content in files.items():
    write_file(path, content)

os.chmod("build.sh", 0o755)
os.chmod("config/hooks/0100-anaconda.chroot", 0o755)

print("✅ Debian ISO build structure created.")
