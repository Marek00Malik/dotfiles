#!/bin/bash
###########################################################################
## This script is responsible for syncing idea configs between enviroments Linux and MacOs to Google Drive cloud.
###########################################################################


set -e
SSH_REMOTE='/ssh_config.tar.gz';
SSH_LINUX="$HOME/.ssh/";
SSH_OS="$HOME/.ssh";

ZSH_BASH_REMOTE='/zsh_bash.tar.gz';
ZSH_BASH_LINUX="$HOME";
ZSH_BASH_OS="$HOME";

params="<upload|downlod>"
OS_SYSTEM='unknown'

if [[ $OSTYPE == "Linux" ]]; then
    OS_SYSTEM='Linux'
    GIT="$HOME/Desktop/GitCode/Personal/dotfiles/Backup"
elif [[ "$(uname -s)" == 'Darwin' ]]; then
    OS_SYSTEM='MacOs'  
    GIT="$HOME/Desktop/GitCode/Personal/dotfiles/Backup"
fi
echo 
echo 
echo -e "Sync system preferences, config files, to Google Drive or from Google Drive"
echo -e "Running sync on $OS_SYSTEM"
echo -e "....................................................."
echo 
echo 

function pull_repo {
    echo -e "....................................................."
    echo "Sync local with remote origin."
    echo "Fetch from remote"
    git pull
    echo -e "....................................................."
}

function push_repo {
    echo -e "....................................................."

    echo "Sync local with remote origin."
    git add --all
    git commit -m "Backup - changes `date '+%Y/%m/%d %H:%M'` `$OS_SYSTEM`"

    git push origin master

    echo -e "....................................................."
}

function sync_upload {
    pull_repo
    echo  -e "Copping files from $OS_SYSTEM to Google Drive";
    if [[ $OS_SYSTEM == "Linux" ]]; then
        SSH_BASE="$SSH_LINUX"
        ZSH_BASH_BASE="$ZSH_BASH_LINUX" 
    elif [[ $OS_SYSTEM == 'MacOs' ]]; then
        SSH_BASE="$SSH_OS"
        ZSH_BASH_BASE="$ZSH_BASH_OS"  
    fi
    echo ''
    echo ''
    echo 'SSH CONFIGS .....'
    tar -czvf "$GIT$SSH_REMOTE" -C "$SSH_BASE" .;
    echo ''
    echo ''

	echo 'ZSH and BASH CONFIGS  ....';
	tar -czvf "$GIT$ZSH_BASH_REMOTE" -C "$ZSH_BASH_BASE" ".zshrc" ".bashrc" ".bash_aliases" ".bash_profile";
    
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
    if [[ $OS_SYSTEM == "Linux" ]]; then
        SSH_BASE="$SSH_LINUX"
        ZSH_BASH_BASE="$ZSH_BASH_LINUX" 
    elif [[ $OS_SYSTEM == 'MacOs' ]]; then
        SSH_BASE="$SSH_OS"
        ZSH_BASH_BASE="$ZSH_BASH_OS"   
    fi
    echo ''
    echo ''
    echo 'SSH CONFIGS .....'
    tar -xvzf "$GIT$SSH_REMOTE" -C "$SSH_BASE";
    echo ''
    echo ''


    echo 'ZSH and BASH CONFIGS  ....';
    tar -xvzf "$GIT$ZSH_BASH_REMOTE" -C "$ZSH_BASH_BASE";
    

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
            echo "   Choose direction of sync: \e[93mFrom \e[39mGoogle Drive | \e[93mTo \e[39mGoogle Drive on $OS_SYSTEM"
            echo " -s <parameter>"
            echo "   ${params}"
            echo
            usage
            ;;
	    s)
            case "$OPTARG" in
            	downlod)
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
