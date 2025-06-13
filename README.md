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

## Dev notes

cd /tmp/d2ibuild
sudo ./build.sh


 - init_debian_iso_project.py
 - chmod +x build.sh config/hooks/0100-anaconda.chroot


# ISO packages installed

**config/package-lists/custom.list.chroot**
task-xfce-desktop
firefox-esr
libreoffice
curl
wget
git

**config/hooks/0100-anaconda.chroot**
#!/bin/bash
set -e
cd /tmp

wget https://repo.anaconda.com/archive/Anaconda3-2024.02-1-Linux-x86_64.sh
bash Anaconda3-2024.02-1-Linux-x86_64.sh -b -p /opt/anaconda
echo 'export PATH=/opt/anaconda/bin:$PATH' >> /etc/profile.d/anaconda.sh



# sort config folder permissions 
sudo chown -R $USER:$USER config/


config/
├── hooks/
│   ├── 0100-anaconda.chroot
│   ├── 0200-slack.chroot
│   └── 0300-element.chroot
├── package-lists/
│   └── custom.list.chroot
└── includes.chroot/
    └── etc/firefox-esr/prefs.js
