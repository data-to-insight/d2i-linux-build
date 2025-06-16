# D2I Linux Alpha Build (v0.1.0)

Custom Ubuntu-based ISO for internal D2I tooling and testing. This is an early attempt to build, streamline deployment and test a Linux desktop environment preconfigured with key apps for our D2I workflows straight out of the box. 
**This is now a working build from release v0.1.0**, see link below for latest release. 



## Quick how to

1. Download latest release/ver (see below for intructions about *Downloading ISO*)
2. Write ISO file to usb stick using a tool like [Rufus](https://rufus.ie), [Etcher](https://www.balena.io/etcher/) or `dd` command
3. Boot PC or virtual machine from usb or ISO file
4. Use in live Mode (no changes saved) or install to disk for full access

### Downloading ISO

latest version is at: [Download D2I Linux v0.1.0](https://github.com/data-to-insight/d2i_linux_build/releases/tag/v0.1.0)
*Note: ISO file located **inside archive** (either ZIP or TAR.GZ) and is not shown as separate download file.*

To extract ISO:

1. Download the ZIP or TAR.GZ file from release (Git doesnt allow direct upload of `.iso` files, so ISO is bundled inside `.zip`|`.tar.gz` archive for compatibility)
2. Extract it on your pc
3. Locate ISO at `output/d2i-custom.iso` inside extracted folder
4. You can boot this ISO in VirtualBox, write it to USB with BalenaEtcher, or install it on pc

### What's an ISO?

An ISO file is a single archive that contains the entire contents of a disc or bootable installation image. In this case, it includes the full D2I Linux operating system – preconfigured with desktop, tools(increasing as we decide on what our core set is), and settings.

You can use the ISO to:

- Boot a virtual machine (e.g. VirtualBox, QEMU)
- Create a bootable live USB (using BalenaEtcher, Rufus, etc)(try without installing)
- Install the system on any PC 
- Give us an open source, consistent, customisable, ready-to-go Linux environment for the d2i team



## What It Includes

- Ubuntu 24.04 LTS (Noble Numbat) base
- XFCE desktop environment (fast/ minimal 
- **Live Mode**: XFCE GUI with auto-login (`d2iuser`) on initial use)
- D2I custom wallpaper (placeholder only atm)
- Slack and Thunderbird auto-start on boot
- Firefox homepage set to https://www.datatoinsight.org
- Anaconda, Jupyter, LibreOffice + common tools preinstalled


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
| **Live Session Autologin** | User `d2iuser` is logged in automatically in live session                |

---

## First Boot

When run via VirtualBox, QEMU, or direct install, you should see:

- XFCE GUI with D2I wallpaper
- App menu incl Firefox, LibreOffice, Slack, Thunderbird
- Slack and Thunderbird autostart
- D2I welcome popup on first boot
- Firefox opens https://www.datatoinsight.org


---

## Build Process

### Final Working Method (Dockerised)

Succeeded by **moving `lb build` command outside Docker image build phase** and instead running it at container runtime:

```bash
docker build -t d2i-live .
docker run --rm -v "$PWD/output:/build/output" d2i-live


---

## Prev attempts - i.e. some background on our approach to this build and why (and Why Failed)

This avoids mounting of privileged paths like `/proc` and `/dev/pts` inside Dockerfile, which seemed to fail repeatedly in (any)unprivileged environments like GitHub Codespaces and GitPod (admitedly on this one i did't use the paid account).

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


## Download for use our latest iso release

[Latest Release](https://github.com/datatoinsight/d2i-linux_build/releases/latest)


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
