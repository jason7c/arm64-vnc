#!/bin/bash

### resolve also symlinks
_current_dir="$(dirname "$(readlink -f "$0")")"

debian=$("${_current_dir}/version_of.sh" debian)
firefox=$("${_current_dir}/version_of.sh" firefox)

main() {
    local key

    if [[ $# -gt 0 ]] ; then

        while [[ $# -gt 0 ]] ; do

            key="$1"

            if [[ "${key}" = '--' ]] ; then
                shift
            fi

            case "${key}" in

                -h )
                    echo "Usage: version_sticker [-h] [-v] [-V] [-f]"
                    echo "-h    help"
                    echo "-v    short version sticker"
                    echo "-V    verbose version sticker"
                    echo "-f    features"
                    ;;

                -f )
                    env | grep "FEATURES_" | sort
                    ;;

                -v )
                    if [[ -n "${firefox}" ]] ; then echo "Firefox ${firefox}" ; fi
                    echo "Debian ${debian}"
                    ;;

                -V )
                    if [[ -n "${firefox}" ]] ; then echo "Firefox ${firefox}" ; fi

                    version=$("${_current_dir}/version_of.sh" jq)
                    if [[ -n "${version}" ]] ; then echo "jq ${version}" ; fi

                    version=$("${_current_dir}/version_of.sh" mousepad)
                    if [[ -n "${version}" ]] ; then echo "Mousepad ${version}" ; fi

                    version=$("${_current_dir}/version_of.sh" nano)
                    if [[ -n "${version}" ]] ; then echo "nano ${version}" ; fi

                    version=$("${_current_dir}/version_of.sh" novnc)
                    if [[ -n "${version}" ]] ; then echo "noVNC ${version}" ; fi

                    version=$("${_current_dir}/version_of.sh" python3)
                    if [[ -n "${version}" ]] ; then echo "Python ${version}" ; fi

                    version=$("${_current_dir}/version_of.sh" tigervnc)
                    if [[ -n "${version}" ]] ; then echo "TigerVNC ${version}" ; fi

                    echo "Debian ${debian}"

                    version=$("${_current_dir}/version_of.sh" websockify)
                    if [[ -n "${version}" ]] ; then echo "websockify ${version}" ; fi
                    ;;
            esac
            shift
        done
    else
        sticker="debian${debian}"

        if [[ -n "${firefox}" ]]; then
            sticker="${sticker}-firefox${firefox}"
        fi
        
        echo "${sticker}"
    fi
}

main $@
