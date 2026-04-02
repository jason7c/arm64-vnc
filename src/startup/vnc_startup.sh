#!/bin/bash
### VNC startup script

### Clean up any stale lock files
vncserver -kill "${DISPLAY}" 2>/dev/null || true
rm -f /tmp/.X*-lock /tmp/.X11-unix/X* 2>/dev/null || true

### Create VNC password
mkdir -p "${HOME}/.vnc"
echo "${VNC_PW}" | vncpasswd -f > "${HOME}/.vnc/passwd"
chmod 600 "${HOME}/.vnc/passwd"

### Create Xfce startup script for VNC
cat > "${HOME}/.vnc/xstartup" << 'EOF'
#!/bin/bash
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
export XDG_SESSION_TYPE=x11
exec startxfce4
EOF
chmod +x "${HOME}/.vnc/xstartup"

### Start VNC server
VIEW_ONLY_OPT=""
if [ "${VNC_VIEW_ONLY}" = "true" ]; then
    VIEW_ONLY_OPT="-viewonly"
fi

vncserver "${DISPLAY}" \
    -depth "${VNC_COL_DEPTH}" \
    -geometry "${VNC_RESOLUTION}" \
    -rfbport "${VNC_PORT}" \
    -rfbauth "${HOME}/.vnc/passwd" \
    -fg \
    ${VIEW_ONLY_OPT}
