# D2I Linux Alpha Build (v0.1.0)

Ubuntu-based ISO for D2I tooling and testing. This is an early attempt to build, deploy(to anyone who'd like to try it) and test a Linux desktop environment preconfigured with key apps towards a data-orientated workflow(incl. D2I's) straight out of the box. An exploratory and very much in-progress investigation into what a D2I open source plug-and-play data-suite might look like for our own team but also any LA data colleagues. 

**This is now a working build from release v0.1.0**
See below for download and usage instructions.

---

## Why Build a Custom Linux ISO for D2I?

Across lots of sectors teams like ours are increasingly exploring more sustainable, cost-effective and open approaches to tooling. This Linux build reflects that shift. We're asking ourselves, can we:

- Put together a free, open-source alternative for D2I use and potentially local authority (data)colleagues
- Package key D2I tools in a ready-to-use format (ideally that will run on any hardware)
- Make it easier for colleagues to try, adopt, (enjoy?) and understand **open-source tools** like Python, Anaconda, Jupyter, and LibreOffice
- Encourage **open standards**, **data transparency**, and **independence from software lock-in**

---

## Common Open Source Benefits

- **Cost saving**: No licence fees or platform lock-in  
- **Transparency**: Code and tools can be audited and understood  
- **Security**: Community-tested, widely deployed systems  
- **Portability**: Run on almost any hardware  
- **Adaptability**: Customise, rebuild and redistribute legally  
- **Shared knowledge**: Aligns with our principles of collaboration and insight-sharing  

Some public teams are already taking steps to switch away from proprietary platforms, e.g.:

- [“We’re done with Teams” — German state uninstalls Microsoft tools](https://economictimes.indiatimes.com/tech/technology/were-done-with-teams-german-state-hits-uninstall-on-microsoft/articleshow/121817207.cms)
- [Denmark exploring open source alternatives to Microsoft](https://cybernews.com/tech/denmark-open-source-software-phase-microsoft/)

By offering a Linux-based, D2I-ready environment, we provide a small but practical step toward possible wider open adoption — while also improving our own portability and resilience. We're learning by doing on this one; but there is potential future value in putting together an in-one desktop solution for both D2I or local authority use.

---

## How to (Quick view)

1. Download latest release/ver (see below for intructions about *Downloading ISO*)
2. Write ISO file to usb stick using a tool like [Rufus](https://rufus.ie), [Etcher](https://www.balena.io/etcher/) or `dd` command
3. Boot PC or virtual machine from usb or ISO file
4. Use in live Mode (no changes saved) or install to disk for full access

---

## How to (Expanded view)

This guide helps you run D2I Linux build from USB stick in **Live Mode** (i.e. try it without installing).

## 1. Download the ISO

Go to the [Latest Release](https://github.com/data-to-insight/d2i_linux_build/releases/latest) and download the ZIP or TAR.GZ file.  
Inside you'll find the ISO file (e.g. `d2i-custom.iso`)

Unzip or extract it so you can access the `.iso` file directly.

---

## 2. Write the ISO to a USB stick

Choose one of the following methods:

### Option A: Use a graphical tool (recommended for beginners)
- [Rufus](https://rufus.ie) (Windows)  
- [Balena Etcher](https://www.balena.io/etcher/) (Windows, macOS, Linux)

**Steps**:
1. Plug in a USB stick (at least 4GB)
2. Open the tool and select your ISO file
3. Choose USB device
4. Click "Flash" or "Start" to write

### Option B: Use `dd` command (Linux/macOS only - advanced)

    sudo dd if=d2i-custom.iso of=/dev/sdX bs=4M status=progress && sync

Replace `/dev/sdX` with the correct USB device name (be very careful – will erase the disk).

---

## 3. Boot from the USB

1. Insert the USB stick into the target machine.
2. Reboot and enter BIOS/boot menu (usually by pressing F12, F2, ESC, or DEL).
3. Select your USB stick as the boot device.

---

## 4. Use D2I Linux

You’ll be offered:
- **Live Mode**: Try the system without making changes to your computer (ideal for testing)
- **Install Mode**: Permanently install the system on a hard drive (for full-time use)



---



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



## What the build/software includes

- Ubuntu 24.04 LTS (Noble Numbat) base
- XFCE desktop environment (fast/ minimal 
- **Live Mode**: XFCE GUI with auto-login (`d2iuser`) on initial use)
- D2I wallpaper (placeholder atm)

---

### Preinstalled Apps


| Application         | Purpose                                                                 |
|---------------------|-------------------------------------------------------------------------|
| **Firefox ESR**      | Web browser, homepage set to https://www.datatoinsight.org             |
| **LibreOffice**      | Office suite (Calc used for spreadsheets)                              |
| **Slack**            | Team communication (installed via `.deb`)                              |
| **Thunderbird**      | Email client                                                           |
| **Anaconda**         | Python data environment, includes Jupyter (installed via custom script)|
| **Zenity**           | Simple GUI dialogs for scripts                                          |
| **curl, wget, git**  | Core CLI tools for dev and data use                                    |
| **Element (Matrix)** | Decentralised chat app, alternative to Teams or Slack                  |
| **OpenVPN Support**  | VPN client support via NetworkManager plugins  
                        ([setup guide](https://wiki.gnome.org/Projects/NetworkManager/VPN))     |



---

## Data Science Environment

D2I Linux build includes Python tools. Access via a post-install hook using `pip` inside the Anaconda environment. Anaconda is preinstalled in `/opt/anaconda3` and added to the system PATH. To start working with notebooks `jupyter notebook`(this opens the browser as per ESCC current set up)

### Preinstalled Python Packages

| Package         | Purpose                                  |
|-----------------|------------------------------------------|
| `pandas`        | Data manipulation and analysis           |
| `numpy`         | Numerical ops                            |
| `matplotlib`    | Plots and visualisation                  |
| `seaborn`       | Statistical visuals                      |
| `openpyxl`      | Excel file reading/writing (xlsx)        |
| `scikit-learn`  | Machine learning tools                   |
| `statsmodels`   | Stats modelling and tests                |
| `jupyter`       | Notebooks for data workflows             |


Available by default via `python` or `jupyter notebook` from terminal or XFCE menu.


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

## Build Process and Learning 

### Final Working Method (Dockerised)

Succeeded by **moving `lb build` command outside Docker image build phase** and instead running it at container runtime:

```bash
docker build -t d2i-live .
docker run --rm -v "$PWD/output:/build/output" d2i-live
```

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


## Download for use our latest iso release

[Latest Release](https://github.com/datatoinsight/d2i-linux_build/releases/latest)



