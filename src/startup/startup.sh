#!/bin/bash
### Main startup script for the headless VNC container

set -e

### Resolve the display variable
export DISPLAY="${DISPLAY:-:1}"

### Start the VNC server in background
/usr/local/bin/vnc_startup.sh &
VNC_PID=$!

### Wait for VNC port to be ready (up to 30 seconds)
echo "Waiting for VNC server to start on port ${VNC_PORT}..."
for i in $(seq 1 30); do
    if bash -c "cat /dev/null > /dev/tcp/localhost/${VNC_PORT}" 2>/dev/null; then
        echo "VNC server is ready."
        break
    fi
    sleep 1
done

### Start noVNC
/usr/local/bin/novnc_startup.sh &

echo "Container started. VNC is available on port ${VNC_PORT}, noVNC on port ${NOVNC_PORT}."
wait
