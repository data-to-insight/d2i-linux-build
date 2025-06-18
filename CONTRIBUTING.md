# Contributing and Dev Notes: D2I Linux ISO Build

This document outlines how to add packages, troubleshoot common issues, and release updated ISO versions. Mainly based on some initial teething issues i experienced whilst attempting to put the d2i build together and figuring out some of the details of adding to a bespoke iso for release. 

---

## Adding New Tools or Packages

### 1. Via `apt` Package Manager (simple tools)

For ref, simple tools are those that are available in the standard Ubuntu (or Debian) repositories or can be installed just by name, e.g. curl, git, openvpn, gnome-sql or do not require downloading .deb files manually, resolving custom dependencies, or adding external repositories.

Edit or create this file:

    config/package-lists/d2i.list.chroot

Example contents:

    curl  
    wget  
    git  
    gnome-sql  
    openvpn  

One line per package. These are pulled via `apt` during ISO build.

---

### 2. Via `.chroot` Hook (for downloads or custom installs)

Unlike the above simple tools, these are tools that require .deb URLs, custom install logic, or external repos (like Azure Data Studio, Anaconda, Element Desktop) need to be installed using .chroot hooks instead. 

Create a new hook script in:

    config/hooks/

Name it something like:

    config/hooks/0310-install-azure-data-studio.chroot

Example content:

    #!/bin/bash  
    set -e  

    echo "Installing Azure Data Studio..."

    wget -O /tmp/azuredatastudio.deb https://go.microsoft.com/fwlink/?linkid=2214176  
    apt install -y /tmp/azuredatastudio.deb || true

Ensure the script is executable:

    chmod +x config/hooks/0310-install-azure-data-studio.chroot

Hook phases can be one of: `chroot`, `binary`, `normal`, or `live`.

---

## Debugging Common Errors

### `mount: /build/chroot/proc: permission denied`

Occurs if trying to mount system paths during Dockerfile build phase.  
**Fix**: Always run `lb build` at container runtime, not during image build.

---

### `No such file or directory`

Make sure folder paths exist before writing files.  
Use:

    mkdir -p config/package-lists  
    mkdir -p config/hooks

---

### `is a directory` error for hooks

Hook files must be **actual shell scripts**, not folders.  
Fix it with:

    touch config/hooks/0400-my-script.chroot  
    chmod +x config/hooks/0400-my-script.chroot  
    nano config/hooks/0400-my-script.chroot

---


## Build Locally

```bash
# Build image
docker build -t d2i-live .
```

# Run image to build ISO
docker run --rm -v "$PWD/output:/build/output" d2i-live

---

### Output

ISO will appear in:

./output/d2i-custom.iso

You can also find it via:

[Latest Release](https://github.com/datatoinsight/d2i-linux_build/releases/latest)

### Proj Structure

d2i_linux_build/
│
├── build.sh                      # ISO build driver script (invokes live-build)
├── Dockerfile                    # Docker wrapper for privileged runtime
├── config/
│   ├── package-lists/            # apt packages to include (e.g. d2i.list.chroot)
│   ├── includes.chroot/          # Files to copy into final image (e.g. wallpaper)
│   └── hooks/                    # Custom install logic (e.g. Anaconda installer)
├── assets/                       # Wallpaper image, etc
├── output/                       # Built ISO is placed here
└── .github/workflows/            # GitHub Actions pipeline (future automation)


### Customised layering

| Layer              | Purpose                                                 |
|--------------------|---------------------------------------------------------|
| package-lists/     | Declare core packages installed via apt           |
| includes.chroot/   | Add files into ISO directly (e.g. wallpapers, configs) |
| hooks/             | Custom shell scripts run during chroot phase   |



## Release Flow

To push new ISO version (after rebuilding):

    git tag v0.1.1  
    git push origin v0.1.1

This will:

- Trigger GitHub Actions workflow  
- Build ISO via Docker  
- Upload ISO to GitHub Releases via `softprops/action-gh-release`


