#!/bin/bash
###########################################################################
## This script handles main menu
###########################################################################

params="<download|upload>"

function usage {
    echo "Usage: $0 [-h] [-s ${params}]"
    echo
    echo
    exit 0
} >&2

if [[ -z "$@" ]]; then
    usage
fi

while getopts "hs:" opt; do
    case $opt in
        h)
            echo "Sync system preferences, config files from<=>to Google Drive"
            echo            echo "Options:"
            echo " -h"
            echo "   Print detailed help screen"
            echo "   Choose direction of sync: From Google Drive | To Google Drive on $OS_SYSTEM"
            echo " -s <parameter>"
            echo "   ${params}"
            echo
            usage
            ;;
        s)
            case "$OPTARG" in
                download)
                    sync_download
                    ;;

                upload)
                    sync_upload
                    ;;

                *)
                    echo 'No parameter selected.'
                    echo 'Choose enviroment: linux, mac_os or google to sync with'
                    echo
                    echo
                    ;;
            esac>&2
            ;;
        ?)
            echo ' ??? ??? What do you want ??? ???'
            usage
            ;;
        *)
            echo 'You did not put in anything'
            ;;
    esac >&2

done