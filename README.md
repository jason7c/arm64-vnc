# arm64-vnc

A Docker image providing a headless Ubuntu 24.04 desktop environment with VNC and noVNC access, built specifically for **arm64** (aarch64) CPUs.

Inspired by [accetto/ubuntu-vnc-xfce-g3](https://github.com/accetto/ubuntu-vnc-xfce-g3), which publishes amd64-only pre-built images. This project builds an equivalent arm64 image using Ubuntu's native arm64 packages.

## Features

- **Ubuntu 24.04** base image (arm64/aarch64)
- **Xfce4** desktop environment
- **TigerVNC** server (installed from apt — fully arm64-native)
- **noVNC** — browser-based VNC client (no VNC viewer needed)
- **Firefox** web browser
- Non-root `headless` user with passwordless sudo

## Ports

| Port | Protocol | Description         |
|------|----------|---------------------|
| 5901 | TCP      | VNC server          |
| 6901 | HTTP     | noVNC web interface |

## Quick Start

### Pull from GitHub Container Registry

```bash
docker pull ghcr.io/jason7c/arm64-vnc:latest
```

### Run the container

```bash
docker run -d \
  --name arm64-vnc \
  -p 5901:5901 \
  -p 6901:6901 \
  ghcr.io/jason7c/arm64-vnc:latest
```

### Access the desktop

- **noVNC (browser)**: Open [http://localhost:6901](http://localhost:6901)
- **VNC client**: Connect to `localhost:5901`
- **Default VNC password**: `headless`

## Configuration

The following environment variables can be set at container start:

| Variable         | Default      | Description                          |
|------------------|--------------|--------------------------------------|
| `VNC_PW`         | `headless`   | VNC password                         |
| `VNC_RESOLUTION` | `1360x768`   | Screen resolution                    |
| `VNC_COL_DEPTH`  | `24`         | Color depth (bits)                   |
| `VNC_PORT`       | `5901`       | VNC server port                      |
| `NOVNC_PORT`     | `6901`       | noVNC web interface port             |
| `VNC_VIEW_ONLY`  | `false`      | Set to `true` for view-only VNC mode |

### Example with custom settings

```bash
docker run -d \
  --name arm64-vnc \
  -p 5901:5901 \
  -p 6901:6901 \
  -e VNC_PW=mysecretpassword \
  -e VNC_RESOLUTION=1920x1080 \
  ghcr.io/jason7c/arm64-vnc:latest
```

## Build Locally

```bash
docker buildx build \
  --platform linux/arm64 \
  -t arm64-vnc:local \
  --load \
  .
```

## GitHub Actions

The included workflow (`.github/workflows/build-and-push.yml`) automatically:

1. Builds the Docker image for `linux/arm64` using QEMU cross-compilation
2. Pushes the image to GitHub Container Registry (`ghcr.io`) on every push to `main`/`master` or when a version tag (`v*`) is pushed
3. Tags the image as `latest` on the default branch

## Source

- Dockerfile: based on the architecture of [accetto/ubuntu-vnc-xfce-g3](https://github.com/accetto/ubuntu-vnc-xfce-g3)
- Pre-built arm64 image: [ghcr.io/jason7c/arm64-vnc](https://ghcr.io/jason7c/arm64-vnc)