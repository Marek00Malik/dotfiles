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

LA_ROOT_DIR='/IDEA/loyalty/';
LA_LINUX="$HOME/Pulpit/GitCode/Statoil/loyalty/.idea/runConfigurations";
LA_OSX='/Users/mmalik/Desktop/GitCode/Statoil/loyalty/.idea/runConfigurations';

EXTRA2_ROOT_DIR='/IDEA/extra/';
EXTRA2_LINUX="$HOME/Pulpit/GitCode/Statoil/extra2/.idea/runConfigurations";
EXTRA2_OSX='/Users/mmalik/Desktop/GitCode/Statoil/extra2/.idea/runConfigurations';

params="<download|upload>"
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
echo -e "Sync project configs, runConfiguration files, to Git Repository or from Git Repository"
echo -e "Running sync on $OS_SYSTEM"
echo -e "....................................................."
echo 
echo 


function sync_upload {
	echo  -e "Coping files from $OS_SYSTEM to Git Repository";
    if [[ $OS_SYSTEM == "Linux" ]]; then
        CES="$CES_LINUX"
        FES="$FES_LINUX" 
        INGO="$INGO_LINUX"  
        LA="$LA_LINUX"  
        EXTRA2="$EXTRA2_LINUX"
    elif [[ $OS_SYSTEM == 'MacOs' ]]; then
        CES="$CES_OSX"
        FES="$FES_OSX"   
        INGO="$INGO_OSX" 
        LA="$LA_OSX"   
        EXTRA2="$INGO_OSX"
    fi

    ##echo "CES ....."
	##mkdir -p "$BACKUP_DIR$CES_ROOT_DIR" && cp -R $CES "$BACKUP_DIR$CES_ROOT_DIR";

	echo 'FES  ....';
	mkdir -p "$BACKUP_DIR$FES_ROOT_DIR" && cp -R $FES "$BACKUP_DIR$FES_ROOT_DIR";

	echo 'INGO  ...';
	mkdir -p "$BACKUP_DIR$INGO_ROOT_DIR" && cp -R $INGO "$BACKUP_DIR$INGO_ROOT_DIR";

	echo 'LA  ...';
	mkdir -p "$BACKUP_DIR$LA_ROOT_DIR" && cp -R $LA "$BACKUP_DIR$LA_ROOT_DIR";

	echo 'EXTRA2 ..';
	mkdir -p "$BACKUP_DIR$EXTRA2_ROOT_DIR" && cp -R $EXTRA2 "$BACKUP_DIR$EXTRA2_ROOT_DIR";

    
    echo '-------------------------------------------------'
    echo 'done'
    git add --all
    git commit -m "IDEA - Changes `date '+%Y/%m/%d %H:%M'` $OS_SYSTEM -> GIT"
    git push
    exit 0
} >&2

function sync_download {
	echo 'Download latest repositrory IDEA settings from GitRepo';

    git pull

    echo  -e "Coping files from Git Repository to $OS_SYSTEM";

    if [[ $OS_SYSTEM == "Linux" ]]; then
        CES="$CES_LINUX"
        FES="$FES_LINUX" 
        INGO="$INGO_LINUX"  
        LA="$LA_LINUX"  
        EXTRA2="$EXTRA2_LINUX"
    elif [[ $OS_SYSTEM == 'MacOs' ]]; then
        CES="$CES_OSX"
        FES="$FES_OSX"   
        INGO="$INGO_OSX" 
        LA="$LA_OSX"   
        EXTRA2="$INGO_OSX"
    fi

    echo "Which project should by synced locally ?"
    echo
    echo "1 - CES | 2 - FES | 3 - INGO | 4 - LA | 5 - EXTRA | 0 - ALL"
    echo

    read -p 'Project to sync: ' projOption

    case $projOption in
        1)
            echo 'Not supported yet !'
            ;;
        2) 
            cp -R "$BACKUP_DIR$FES_ROOT_DIR" $FES
            ;;
        3)
            cp -R "$BACKUP_DIR$INGO_ROOT_DIR" $INGO
            ;;
        4)
            cp -R "$BACKUP_DIR$LA_ROOT_DIR" $LA
            ;;
        5) 
            cp -R "$BACKUP_DIR$EXTRA2_ROOT_DIR" $EXTRA2
            ;;
        0)  
            echo 'Not supported yet !'
            ;;

        ?)
            echo '??? ??? WRONG ??? ???'
            exit 1
            ;;
        *)
            echo 'Exit with no action'
            exit 0
            ;;
    esac >&2
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
			echo "Sync project config OperatingSystem\Git Repository"
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
            	upload)
                    sync_upload
                    ;;
 				download)
                    sync_download
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
