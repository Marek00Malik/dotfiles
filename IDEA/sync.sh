#!/bin/bash
###########################################################################
## This script is responsible for syncing idea configs between enviroments Linux and MacOs to Google Drive cloud.
###########################################################################


set -e
CES_ROOT_DIR='/IDEA/ces/';
CES_LINUX="$HOME/Pulpit/GitCode/Statoil/engage/.idea/runConfigurations";
CES_OSX='';

FES_ROOT_DIR='/IDEA/fes/';
FES_LINUX="$HOME/Pulpit/GitCode/Statoil/fuel-e-service/.idea/runConfigurations";
FES_OSX='/Users/mmalik/Desktop/GitCode/Statoil/fuel-e-service/.idea/runConfigurations';

INGO_ROOT_DIR='/IDEA/ingo/';
INGO_LINUX="$HOME/Pulpit/GitCode/Statoil/ingo/.idea/runConfigurations";
INGO_OSX='/Users/mmalik/Desktop/GitCode/Statoil/ingo/.idea/runConfigurations';

EXTRA2_ROOT_DIR='/IDEA/extra/';
EXTRA2_LINUX="$HOME/Pulpit/GitCode/Statoil/extra2/.idea/runConfigurations";
EXTRA2_OSX='/Users/mmalik/Desktop/GitCode/Statoil/extra2/.idea/runConfigurations';

params="<from|to>"
OS_SYSTEM='unknown'

if [[ $OSTYPE == "Linux" ]]; then
    OS_SYSTEM='Linux'
    BACKUP_DIR='/Users/mmalik/Desktop/GitCode/Personal/dotfiles' ##fixme
elif [[ "$(uname -s)" == 'Darwin' ]]; then
    OS_SYSTEM='MacOs'  
    BACKUP_DIR='/Users/mmalik/Desktop/GitCode/Personal/dotfiles'
fi

if [[ $OS_SYSTEM == 'unknown' ]]; then 
    echo "SYSTEM not recognized, check uname command result on your machine!"
    exit 1
fi

echo 
echo 
echo -e "\e[1mSync project configs, runConfiguration files, \e[92mto Git Repository\e[39m or \e[93mfrom Git Repository\e[39m"
echo -e "Running sync on \e[93m$OS_SYSTEM \e[0m"
echo -e "....................................................."
echo 
echo 


function sync_to {
	echo  -e "Copping files from  \e[96m$OS_SYSTEM \e[92mto \e[92mGit Repository \e[39m";
    if [[ $OS_SYSTEM == "Linux" ]]; then
        CES="$CES_LINUX"
        FES="$FES_LINUX" 
        INGO="$INGO_LINUX"  
        EXTRA2="$EXTRA2_LINUX"
    elif [[ $OS_SYSTEM == 'MacOs' ]]; then
        CES="$CES_OSX"
        FES="$FES_OSX"   
        INGO="$INGO_OSX"  
        EXTRA2="$INGO_OSX"
    fi

    ##echo "CES ....."
	##mkdir -p "$BACKUP_DIR$CES_ROOT_DIR" && cp -R $CES "$BACKUP_DIR$CES_ROOT_DIR";

	echo 'FES  ....';
	mkdir -p "$BACKUP_DIR$FES_ROOT_DIR" && cp -R $FES "$BACKUP_DIR$FES_ROOT_DIR";

	echo 'INGO  ...';
	mkdir -p "$BACKUP_DIR$INGO_ROOT_DIR" && cp -R $INGO "$BACKUP_DIR$INGO_ROOT_DIR";

	echo 'EXTRA2 ..';
	mkdir -p "$BACKUP_DIR$EXTRA2_ROOT_DIR" && cp -R $EXTRA2 "$BACKUP_DIR$EXTRA2_ROOT_DIR";

    
    echo '-------------------------------------------------'
    echo 'done'
    exit 0
} >&2

function sync_from {
	echo 'Not yet supported - under development';
} >&2

function usage {
    echo "Usage: $0 [-h] [-s ${params}]"
    exit 1
} >&2

if [[ -z "$@" ]]; then
    usage
fi

while getopts "hs:" opt; do
    case $opt in
        h)
			echo "Sync project config files from<=>to OperatingSystem\Git Repository"
            echo
            echo "Options:"
            echo " -h"
            echo "   Print detailed help screen"
            echo " -s <parameter>"
            echo "   ${params}"
            echo
            usage
            ;;
	    s)
            case "$OPTARG" in
            	from)
                    sync_from
                    ;;
 				to)
                    sync_to
					;;
                *)
                    echo 'No parameter selected.'
                    echo 'Choose enviroment: linux, mac_os or google to sync with'
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
