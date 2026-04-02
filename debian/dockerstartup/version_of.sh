#!/bin/bash

# cSpell:disable

case "$1" in
    debian )
        ### source example: 11.6
        echo $(cat /etc/debian_version 2>/dev/null | grep -Po -m1 '^[0-9.]+$')
        ;;
    firefox )
        ### source example: Mozilla Firefox 115.0esr
        echo $(firefox-esr -v 2>/dev/null | grep -Po -m1 '(?<=Firefox\s)[0-9a-zA-Z.-]+')
        ;;
    jq )
        ### source sample: jq-1.5-1-a5b5cbe
        echo $(jq --version 2>/dev/null | grep -Po -m1 '(?<=jq\-)[0-9.]+')
        ;;
    mousepad )
        ### Mousepad requires display
        echo $(mousepad --version 2>/dev/null | grep -Po -m1 '(?<=Mousepad\s)[0-9.]+')
        ;;
    nano )
        ### source example: GNU nano, version 4.8
        echo $(nano --version 2>/dev/null | grep -Po -m1 '(?<=version\s)[0-9.]+')
        ;;
    novnc | no-vnc )
        echo $(cat "${NOVNC_HOME}"/package.json 2>/dev/null | grep -Po -m1 '(?<=\s"version":\s")[0-9.]+')
        ;;
    python3 )
        ## source example: Python 3.9.2
        echo $(python3 --version 2>/dev/null | grep -Po -m1 '[0-9.]+$')
        ;;
    tigervnc | tiger-vnc | vncserver | vnc-server | vnc )
        ### source example: Xvnc TigerVNC 1.11.0 - built Sep  8 2020 12:27:03
        echo $(Xvnc -version 2>&1 | grep -Po -m1 '(?<=Xvnc TigerVNC\s)[0-9.]+')
        ;;
    websockify )
        echo $(cat "${NOVNC_HOME}"/utils/websockify/CHANGES.txt 2>/dev/null | grep -Po -m1 '^[0-9.]+')
        ;;
esac
