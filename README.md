# D2I Linux Alpha Build (v0.0.9)

Custom Ubuntu-based ISO for internal D2I tooling and testing. This is an early attempt to streamline deployment and testing of a desktop environment preconfigured for common D2I workflows.

repo contains:

- ISO build scripts using `live-build`
- Dockerfile for building in a container
- GitHub Actions workflow for automated ISO release (planned)
- Preinstalled tooling and light branding

---

## Summary

- **Base Distribution**: Ubuntu 24.04 LTS (Noble)
- **Desktop**: XFCE (lightweight, stable)
- **Architecture**: amd64
- **Live Mode**: XFCE GUI with auto-login (`d2iuser`)
- **Installer**: Available during live session
- **Release Status**: Alpha (non-production)

---

## Preinstalled Apps

| Application     | Purpose                                                                 |
|-----------------|--------------------------------------------------------------------------|
| **Firefox ESR** | Web browser, homepage set to https://www.datatoinsight.org              |
| **LibreOffice** | Office suite (Calc used for spreadsheets)                               |
| **Slack**       | Team communication (installed via `.deb`)                               |
| **Thunderbird** | Email client                                                            |
| **Anaconda**    | Python data environment, includes Jupyter (installed via custom script) |
| **Zenity**      | Simple GUI dialogs for scripts                                           |
| **curl, wget, git** | Core CLI tools for dev and data use                                 |

---

## D2I Custom

| Feature                     | Description                                                                 |
|-----------------------------|-----------------------------------------------------------------------------|
| **Wallpaper**              | Custom D2I wallpaper (`d2i-wallpaper.png`) in `/usr/share/backgrounds/`     |
| **Welcome Message**        | First login popup: “Your new D2I build has installed.”                      |
| **Autostart Apps**         | Slack and Thunderbird autostart on live boot or first login                 |
| **Firefox Homepage**       | Set to https://www.datatoinsight.org                                       |
| **Live Session Autologin** | User `d2iuser` is logged in automatically in the live session                |

---

## First Boot

When run via VirtualBox, QEMU, or direct install, the following should be visible:

- XFCE GUI with D2I wallpaper
- App menu incl Firefox, LibreOffice, Slack, Thunderbird
- Slack and Thunderbird autostart
- D2I welcome popup on first boot
- Firefox opens https://www.datatoinsight.org


---

## Build Process

### Final Working Method (Dockerised)

Succeeded by **moving the `lb build` command outside the Docker image build phase** and instead running it at container runtime:

```bash
docker build -t d2i-live .
docker run --rm -v "$PWD/output:/build/output" d2i-live


---

## PRev attempts (and Why Failed)

This avoids the mounting of privileged paths like `/proc` and `/dev/pts` inside the Dockerfile, which fails in unprivileged environments like GitHub Codespaces and GitPod.

| Attempt                         | Description                                 | Status | Problem                                                                 |
|---------------------------------|---------------------------------------------|--------|-------------------------------------------------------------------------|
| **Live-build in Dockerfile**    | Ran `lb build` inside `Dockerfile`          | ❌     | Failed to mount `/proc`, `/dev/pts` during `chroot` stage              |
| `--chroot false`               | Attempted to skip chroot                    | ❌     | Not respected by all live-build hooks, still attempted to mount        |
| **build.sh with sudo**          | Used `sudo` in container                    | ❌     | `sudo: command not found` (Docker build runs as root already)          |
| **GitHub Actions build**        | Tried full pipeline in Actions              | ❌     | Same mount errors, GitHub runners do not support `--privileged` builds |
| **Privileged local Docker run** | Used Docker with `docker run`              | ✅     | Worked, allowed mounts during runtime                                  |
| **GitPod Codespaces**           | Tested container-in-container(paywall)               | ❌     | Still hit `/proc` and `/dev/pts` restrictions due to nesting           |

---

## Build Locally

```bash
# Build image
docker build -t d2i-live .

# Run image to build ISO
docker run --rm -v "$PWD/output:/build/output" d2i-live



### Output

The ISO will appear in:

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
| hooks/             | Custom shell scripts run during the chroot phase   |


### Releasing new iso ver

Publish new iso release:

```bash
git tag v0.1.0
git push origin v0.1.0


### Next Steps

- tbc



## Internal Dev notes

cd /tmp/d2ibuild
sudo ./build.sh

**Need to biuld into /tmp**
cd /workspaces/d2i_linux_build
chmod +x build_in_tmp.sh
./build_in_tmp.sh


docker build -t d2i-live .
docker run --rm -v "$PWD/output:/build/output" d2i-live

problems occur round trying to mount and /proc
mount: /build/chroot/proc: permission denied
mount: /build/chroot/dev/pts: permission denied



**To build**
docker build -t d2i-live .
docker run --rm -it   --privileged   -v "$PWD/output":/build/output   d2i-live   bash -c "./build.sh && lb build && mv live-image-amd64.hybrid.iso output/d2i-custom.iso"
