#!/bin/bash
### noVNC startup script

### Start noVNC websockify proxy
"${NOVNC_HOME}/utils/novnc_proxy" \
    --vnc "localhost:${VNC_PORT}" \
    --listen "${NOVNC_PORT}" \
    --web "${NOVNC_HOME}"
