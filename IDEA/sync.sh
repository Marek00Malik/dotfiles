#!/bin/bash
###########################################################################
## This script is responsible for syncing idea configs between enviroments Linux and MacOs to Google Drive cloud.
###########################################################################

source "../common/git-functions.sh"
source "../common/tar-gpg-operations.sh"

set -e
CES_ROOT_DIR='/IDEA/ces/';
CES_LINUX="$HOME/Pulpit/GitCode/CK/engage/.idea/runConfigurations";
CES_OSX='';

FES_ROOT_DIR='/IDEA/fes/';
FES_LINUX="$HOME/Pulpit/GitCode/CK/fuel-e-service/.idea/runConfigurations";
FES_OSX='/Users/mmalik/Desktop/GitCode/Statoil/fuel-e-service/.idea/runConfigurations';

INGO_ROOT_DIR='/IDEA/ingo/';
INGO_LINUX="$HOME/Pulpit/GitCode/CK/ingo/.idea/runConfigurations";
INGO_OSX='/Users/mmalik/Desktop/GitCode/Statoil/ingo/.idea/runConfigurations';

LA_ROOT_DIR='/IDEA/loyalty/';
LA_LINUX="$HOME/Pulpit/GitCode/CK/loyalty/.idea/runConfigurations";
LA_OSX='/Users/mmalik/Desktop/GitCode/Statoil/loyalty/.idea/runConfigurations';

EXTRA2_ROOT_DIR='/IDEA/extra/';
EXTRA2_LINUX="$HOME/Pulpit/GitCode/CK/extra2/.idea/runConfigurations";
EXTRA2_OSX='/Users/mmalik/Desktop/GitCode/Statoil/extra2/.idea/runConfigurations';

params="<download|upload>"
OS_SYSTEM='unknown'

if [[ "$(uname -s)" == "Linux" ]]; then
    OS_SYSTEM='Linux'
    GIT_DIR='/Users/mmalik/Desktop/GitCode/Personal/dotfiles/IDEA' 
    CES_DIR="$CES_LINUX_DIR"
    FES_DIR="$FES_LINUX_DIR" 
    INGO_DIR="$INGO_LINUX_DIR"  
    LA_DIR="$LA_LINUX_DIR"  
    EXTRA2_DIR="$EXTRA2_LINUX_DIR"
elif [[ "$(uname -s)" == 'Darwin' ]]; then
    OS_SYSTEM='MacOs'  
    GIT_DIR="$HOME/Desktop/GitCode/Personal/dotfiles/IDEA"  
    CES_DIR="$CES_OSX_DIR"
    FES_DIR="$FES_OSX_DIR"   
    INGO_DIR="$INGO_OSX_DIR" 
    LA_DIR="$LA_OSX_DIRX"   
    EXTRA2_DIR="$INGO_OSX_DIRSX"
fi

echo 
echo 
echo -e "Sync project configs, runConfiguration files, to Git Repository or from Git Repository"
echo -e "Running sync on $OS_SYSTEM"
echo -e "....................................................."
echo 

function sync_upload {
	echo  -e "Coping files from $OS_SYSTEM to Git Repository";

    ##echo "CES ....."
	##mkdir -p "$BACKUP_DIR$CES_ROOT_DIR" && cp -R $CES "$BACKUP_DIR$CES_ROOT_DIR";

	echo 'FES  ....';
    compress_and_encrypt "$GIT_DIR$FES_REMOTE_FILENAME" "$FES_DIR";

	echo 'INGO  ...';
	compress_and_encrypt "$GIT_DIR$INGO_REMOTE_FILENAME" "$INGO_DIR";

	echo 'LA  ...';
    compress_and_encrypt "$GIT_DIR$LA_REMOTE_FILENAME" "$LA_DIR";

	echo 'EXTRA2 ..';
    compress_and_encrypt "$GIT_DIR$EXTRA2_REMOTE_FILENAME" "$EXTRA2_DIR";

    push_repo

} >&2

function sync_download {
	echo 'Download latest repositrory IDEA settings from GitRepo';

    echo  -e "Coping files from Git Repository to $OS_SYSTEM";

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
    esac
} >&2

. ../common/main_menu.sh