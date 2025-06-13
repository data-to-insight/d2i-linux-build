## D2I Linux Alpha Build (v0.0.9)

Custom Debian-based ISO for internal D2I tooling and testing. Jusst an initial attempt to get this off the ground in case anyone wants to give it a go - any suggestions obv welcome. Aside the below it's fairly bare bones for now with a bit of obv d2i customisation and some of the core apps we're likely to have in use. 

---

### Base

- **Distribution**: Debian 12 (Bookworm)
- **Architecture**: amd64
- **Desktop Environment**: XFCE (lightweight and stable)
- **Installer**: Included (`--debian-installer live`)
- **Boot Mode**: Live CD with install option

---

### Preinstalled Apps

| Application     | Purpose                                                             |
|-----------------|----------------------------------------------------------------------|
| **Firefox ESR** | Web browser (homepage pre-set [https://www.datatoinsight.org](https://www.datatoinsight.org)) |
| **LibreOffice** | Office suite (Excel via LibreOffice Calc)                |
| **Slack**       | Team comms (via official .deb)                    |
| **Thunderbird** | Email client                                                        |
| **Anaconda**    | Python env, includes Jupyter                                |
| **Zenity**      | GUI dialog tool                           |
| **curl, wget, git** | CLI tools - network and dev use                              |

---

### Customisations

- **Wallpaper**: Pale off-white background incl D2I logo (top-left)
- **Welcome Message**: You should see the notification on first boot  
  _“Your new D2I build has installed.”_
- **Autostart Apps**:
  - Slack
  - Thunderbird
- **Firefox Homepage**: Set to [https://www.datatoinsight.org](https://www.datatoinsight.org)


### First Boot

Booted in VirtualBox, QEMU, or installed, users will(should :)  see:

- XFCE GUI desktop
- Custom D2I wallpaper (logo in top-left)
- Slack, Firefox, Thunderbird, LibreOffice in the app menu
- Slack and Thunderbird autostarting on first login
- Welcome popup message:
  _“Your new D2I build has installed.”_
- Firefox defaults [https://www.datatoinsight.org](https://www.datatoinsight.org)

Live sessions will auto-login. If installed, users will create their own login credentials.


---

### Dev Notes

- Built using `live-build` on GitHub Actions and/or local VM
- ISO auto-uploaded to GitHub Releases when tagged with `v*`
- Release type: **alpha** — for internal trial only
- Live user is set to d2iuser, no log in for intiial load and live for testing (but will ask user in install/set up)

---

### Download

[ISO can be downloaded](https://github.com/datatoinsight/d2i-linux_build/releases/latest)


## Dev notes

cd /tmp/d2ibuild
sudo ./build.sh

**Need to biuld into /tmp**
cd /workspaces/d2i_linux_build
chmod +x build_in_tmp.sh
./build_in_tmp.sh