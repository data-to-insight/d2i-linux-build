
## Build Process and Learning 

Getting a linux build process working within D2I's usual tech stack in Git Codespaces, has proven to be more difficult than initially thought (esp given that's essentially a virtual box on Linux). Some of the formatted notes regarding one of the most frustrating blockers (mount `/proc`, `/dev/pts` during `chroot` stage) are included here in case of use to someone else. 


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

