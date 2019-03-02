#!/bin/bash
###########################################################################
## This script is responsible for syncing idea configs between enviroments Linux and MacOs to Google Drive cloud.
###########################################################################
source "../common/git-functions.sh"

set -e
SSH_REMOTE='/ssh_config.tar.gz';
SSH_LINUX="$HOME/.ssh/";
SSH_OS="$HOME/.ssh";

ZSH_BASH_REMOTE='/zsh_bash.tar.gz';
ZSH_BASH_LINUX="$HOME";
ZSH_BASH_OS="$HOME";

WORK_REMOTE='/work.tar.gz';
WORK_LINUX="$HOME/Dokumenty/WORK/projects/";
WORK_OS="$HOME/Documents/WORK/projects/";

params="<upload|downlod>"
OS_SYSTEM='unknown'
GIT="$HOME/Desktop/GitCode/Personal/dotfiles/Backup"

if [[ $OSTYPE == "Linux" ]]; then
    OS_SYSTEM='Linux'
    SSH_BASE="$SSH_LINUX"
    ZSH_BASH_BASE="$ZSH_BASH_LINUX" 
    WORK_BASE="$WORK_LINUX"
elif [[ "$(uname -s)" == 'Darwin' ]]; then
    OS_SYSTEM='MacOs'     
    SSH_BASE="$SSH_OS"
    ZSH_BASH_BASE="$ZSH_BASH_OS"  
    WORK_BASE="$WORK_OS"
fi
echo 
echo 
echo -e "Sync system preferences, config files, to Google Drive or from Google Drive"
echo -e "Running sync on $OS_SYSTEM"
echo -e "....................................................."
echo 
echo 


function sync_upload {
    pull_repo
    echo  -e "Copping files from $OS_SYSTEM to Google Drive";
    echo ''
    echo ''
    echo 'SSH CONFIGS .....'

    tar -czvf "$GIT$SSH_REMOTE" -C "$SSH_BASE" .;
    gpg --batch --yes --output "$GIT$SSH_REMOTE.gpg" --recipient "info@code-house.pl" --encrypt "$GIT$SSH_REMOTE";
    rm "$GIT$SSH_REMOTE";

    echo ''
    echo ''

	echo 'ZSH and BASH CONFIGS  ....';
	tar -czvf "$GIT$ZSH_BASH_REMOTE" -C "$ZSH_BASH_BASE" ".zshrc" ".bashrc" ".bash_aliases" ".bash_profile";
    gpg --batch --yes --output "$GIT$ZSH_BASH_REMOTE.gpg" --recipient "info@code-house.pl" --encrypt "$GIT$ZSH_BASH_REMOTE";
    rm "$GIT$ZSH_BASH_REMOTE";
    
    echo ''
    echo ''
    
    echo 'WORK DIR .....'
    tar -czvf "$GIT$WORK_REMOTE" -C "$WORK_BASE" --exclude="db_dumps" .;
    gpg --batch --yes --output "$GIT$WORK_REMOTE.gpg" --recipient "info@code-house.pl" --encrypt "$GIT$WORK_REMOTE";
    rm "$GIT$WORK_REMOTE";
    
    echo ''
    echo ''
    echo '-------------------------------------------------'

    push_repo

    echo 'done'
    exit 0
} >&2

function sync_download {
    pull_repo

	echo  -e "Copping files from Repository to $OS_SYSTEM";
    echo ''
    echo ''
    echo 'SSH CONFIGS .....'
    if [[ ! -d "$SSH_BASE" ]]; then
        echo "CREATING DIR: $SSH_BASE"
        mkdir -p "$SSH_BASE"
    fi
    gpg --batch --yes --output "$GIT$SSH_REMOTE" --decrypt "$GIT$SSH_REMOTE.gpg";
    tar -xvzf "$GIT$SSH_REMOTE" -C "$SSH_BASE";
    rm "$GIT$SSH_REMOTE";

    echo ''
    echo ''


    echo 'ZSH and BASH CONFIGS  ....';
    gpg --batch --yes --output "$GIT$ZSH_BASH_REMOTE" --decrypt "$GIT$ZSH_BASH_REMOTE.gpg";
    tar -xvzf "$GIT$ZSH_BASH_REMOTE" -C "$ZSH_BASH_BASE";
    rm "$GIT$ZSH_BASH_REMOTE";
    
    echo ''
    echo ''
    
    echo 'WORK DIR .....'
    if [[ ! -d "$WORK_BASE" ]]; then
        echo "CREATING DIR: $WORK_BASE"
        mkdir -p "$WORK_BASE"
    fi
    gpg --batch --yes --output "$GIT$WORK_REMOTE" --decrypt "$GIT$WORK_REMOTE.gpg";
    tar -xvzf "$GIT$WORK_REMOTE" -C "$WORK_BASE";
    rm "$GIT$WORK_REMOTE";

    echo ''
    echo ''
    echo '-------------------------------------------------'

    echo 'done'

    exit 0
} >&2 

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
            echo
            echo "Options:"
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
