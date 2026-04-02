ARG BASEIMAGE=ubuntu
ARG BASETAG=24.04

FROM ${BASEIMAGE}:${BASETAG}

ARG ARG_VNC_COL_DEPTH=24
ARG ARG_VNC_DISPLAY=:1
ARG ARG_VNC_PORT=5901
ARG ARG_VNC_PW=headless
ARG ARG_VNC_RESOLUTION=1360x768
ARG ARG_VNC_VIEW_ONLY=false
ARG ARG_NOVNC_PORT=6901
ARG ARG_HEADLESS_USER_ID=1001
ARG ARG_HEADLESS_USER_NAME=headless
ARG ARG_HEADLESS_USER_GROUP_ID=1001
ARG ARG_HEADLESS_USER_GROUP_NAME=headless
ARG ARG_HOME=/home/headless

ENV \
    DEBIAN_FRONTEND=noninteractive \
    DISPLAY="${ARG_VNC_DISPLAY}" \
    VNC_COL_DEPTH="${ARG_VNC_COL_DEPTH}" \
    VNC_PORT="${ARG_VNC_PORT}" \
    VNC_PW="${ARG_VNC_PW}" \
    VNC_RESOLUTION="${ARG_VNC_RESOLUTION}" \
    VNC_VIEW_ONLY="${ARG_VNC_VIEW_ONLY}" \
    NOVNC_PORT="${ARG_NOVNC_PORT}" \
    NOVNC_HOME="/usr/libexec/noVNCdim" \
    HEADLESS_USER_ID="${ARG_HEADLESS_USER_ID}" \
    HEADLESS_USER_NAME="${ARG_HEADLESS_USER_NAME}" \
    HEADLESS_USER_GROUP_ID="${ARG_HEADLESS_USER_GROUP_ID}" \
    HEADLESS_USER_GROUP_NAME="${ARG_HEADLESS_USER_GROUP_NAME}" \
    HOME="${ARG_HOME}" \
    NO_AT_BRIDGE=1

### Install essential packages
RUN apt-get update && apt-get install -y \
        curl \
        dbus-x11 \
        gettext-base \
        jq \
        nano \
        psmisc \
        python3 \
        python3-numpy \
        sudo \
        tini \
        wget \
        xauth \
        xinit \
        x11-xserver-utils \
        xdg-utils \
    && rm -rf /var/lib/apt/lists/*

### Install Xfce4 desktop environment
RUN apt-get update && apt-get install -y \
        xfce4 \
        xfce4-terminal \
        elementary-xfce-icon-theme \
        mousepad \
    && rm -rf /var/lib/apt/lists/*

### Install TigerVNC server (arm64-compatible via apt)
RUN apt-get update && apt-get install -y \
        tigervnc-standalone-server \
        tigervnc-common \
    && rm -rf /var/lib/apt/lists/*

### Install noVNC and websockify
RUN mkdir -p "${NOVNC_HOME}"/utils/websockify \
    && wget -qO- https://github.com/novnc/noVNC/archive/v1.5.0.tar.gz \
        | tar xzf - --strip 1 -C "${NOVNC_HOME}" \
    && wget -qO- https://github.com/novnc/websockify/archive/v0.12.0.tar.gz \
        | tar xzf - --strip 1 -C "${NOVNC_HOME}"/utils/websockify \
    && chmod 755 "${NOVNC_HOME}"/utils/novnc_proxy

### Add noVNC index.html
RUN printf '<!DOCTYPE html>\n\
<html>\n\
    <head>\n\
        <title>noVNC</title>\n\
        <meta charset="utf-8"/>\n\
        <meta http-equiv="refresh" content="10; url='"'"'vnc.html'"'"'" />\n\
    </head>\n\
    <body>\n\
    <p><a href="vnc_lite.html">noVNC Lite Client</a></p>\n\
    <p><a href="vnc.html">noVNC Full Client</a></p>\n\
    <p>Full Client will start automatically in 10 seconds...</p>\n\
    </body>\n\
</html>\n' > "${NOVNC_HOME}"/index.html

### Install Firefox
RUN apt-get update && apt-get install -y \
        firefox \
    && rm -rf /var/lib/apt/lists/*

### Create headless user
RUN groupadd --gid "${ARG_HEADLESS_USER_GROUP_ID}" "${ARG_HEADLESS_USER_GROUP_NAME}" \
    && useradd --uid "${ARG_HEADLESS_USER_ID}" \
               --gid "${ARG_HEADLESS_USER_GROUP_ID}" \
               --create-home \
               --home-dir "${ARG_HOME}" \
               --shell /bin/bash \
               "${ARG_HEADLESS_USER_NAME}" \
    && echo "${ARG_HEADLESS_USER_NAME} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/headless \
    && chmod 0440 /etc/sudoers.d/headless

### Copy startup scripts
COPY src/startup/ /usr/local/bin/
RUN chmod +x /usr/local/bin/startup.sh \
              /usr/local/bin/vnc_startup.sh \
              /usr/local/bin/novnc_startup.sh

### Copy desktop files and home resources
COPY src/home/ "${ARG_HOME}"/
RUN chown -R "${ARG_HEADLESS_USER_ID}":"${ARG_HEADLESS_USER_GROUP_ID}" "${ARG_HOME}"

WORKDIR "${ARG_HOME}"

USER "${ARG_HEADLESS_USER_NAME}"

EXPOSE "${VNC_PORT}"
EXPOSE "${NOVNC_PORT}"

ENTRYPOINT ["/usr/bin/tini", "--", "/usr/local/bin/startup.sh"]
