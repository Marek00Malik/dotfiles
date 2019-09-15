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
    read -p "Download or upload data? (D)ownload/(U)pload" -n 1 -r
    echo    # (optional) move to a new line
    
    if [[ $REPLY =~ ^[(Dd)]$ ]]; then
        sync_download
    elif [[ $REPLAY =~ ^[(Uu)]$ ]]; then
        sync_upload            
    fi
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
            read -p "Download or upload data? (D)ownload/(U)pload" -n 1 -r
            echo    # (optional) move to a new line
            if [[ $REPLY =~ ^[(Dd)]$ ]]; then
                sync_download
            elif [[ $REPLAY =~ ^[(Uu)]$ ]]; then
                sync_upload            

            fi
            ;;
    esac >&2

done