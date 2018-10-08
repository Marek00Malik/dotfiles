#!/bin/bash
###########################################################################
## This script is responsible for syncing idea configs between enviroments Linux and MacOs to Google Drive cloud.
###########################################################################


set -e
SSH_REMOTE='/Backup/ssh_config.tar.gz';
SSH_LINUX="$HOME/.ssh/";
SSH_OS='';

ZSH_BASH_REMOTE='/Backup/zsh_bash.tar.gz';
ZSH_BASH_LINUX="$HOME";
ZSH_BASH_OS='';

GPG_REMOTE='/Backup/gpg.tar.gz';
GPG_LINUX="$HOME/.gnupg"
GPG_OS='';

params="<from|to>"
OS_SYSTEM='unknown'

if [[ $OSTYPE == *"linux"* ]]; then
    OS_SYSTEM='Linux'
    GIT="$HOME/Desktop/GitCode/Personal/.backups"
elif [[ $OSTYPE == 'macos' ]]; then
    OS_SYSTEM='MacOs'  
    GIT="$HOME/Desktop/GitCode/Personal/.backups"
fi
echo 
echo 
echo -e "\e[1mSync system preferences, config files, \e[92mto Google Drive\e[39m or \e[93mfrom Google Drive\e[39m"
echo -e "Running sync on \e[93m$OS_SYSTEM \e[0m"
echo -e "....................................................."
echo 
echo 

fetch_repo


function fetch_repo {
    echo -e "....................................................."
    echo "Sync local with remote origin."
    echo "Fetch from remote"
    git fetch origin master
    echo -e "....................................................."
}

function push_repo {
    echo -e "....................................................."

    echo "Sync local with remote origin."
    git add --all
    git commit -m "Update Repo with `$OS_SYSTEM`"

    git push origin master

    echo -e "....................................................."
}

function sync_to {
    echo  -e "Copping files from  \e[96m$OS_SYSTEM \e[92m \e[92mto Google Drive \e[39m";
    if [[ $OS_SYSTEM == "Linux" ]]; then
        SSH_BASE="$SSH_LINUX"
        ZSH_BASH_BASE="$ZSH_BASH_LINUX" 
        GPG_BASE="$GPG_LINUX"  
    elif [[ $OS_SYSTEM == 'MacOs' ]]; then
        SSH_BASE="$SSH_OS"
        ZSH_BASH_BASE="$ZSH_BASH_OS"   
        GPG_BASE="$GPG_OS"
    fi
    echo ''
    echo ''
    echo 'SSH CONFIGS .....'
    tar -czvf "$GIT$SSH_GOGLE_DRIVE" --absolute-names -C "$SSH_BASE" .;
    echo ''
    echo ''


	echo 'ZSH and BASH CONFIGS  ....';
	tar -czvf "$GIT$ZSH_BASH_GOGLE_DRIVE" --absolute-names -C "$ZSH_BASH_BASE" ".zshrc" ".bashrc" ".bash_aliases";
    
    echo ''
    echo ''
    echo '-------------------------------------------------'
    echo 'done'

    echo 'GPG  ....';
    tar -czvf "$GIT$GPG_GOGLE_DRIVE" --absolute-names -C "$GPG_BASE" .;
    
    echo ''
    echo ''
    echo '-------------------------------------------------'

    push_repo

    echo 'done'
    exit 0
} >&2

function sync_from {
	echo  -e "Copping files \e[93mfrom Repository\e[39mto \e[96m$OS_SYSTEM";
    if [[ $OS_SYSTEM == "Linux" ]]; then
        SSH_BASE="$SSH_LINUX"
        ZSH_BASH_BASE="$ZSH_BASH_LINUX" 
        GPG_BASE="$GPG_LINUX"  
    elif [[ $OS_SYSTEM == 'MacOs' ]]; then
        SSH_BASE="$SSH_OS"
        ZSH_BASH_BASE="$ZSH_BASH_OS"   
        GPG_BASE="$GPG_OS"
    fi
    echo ''
    echo ''
    echo 'SSH CONFIGS .....'
    tar -xvzf "$GIT$SSH_GOGLE_DRIVE" -C "$SSH_BASE";
    echo ''
    echo ''


    echo 'ZSH and BASH CONFIGS  ....';
    tar -xvzf "$GIT$ZSH_BASH_GOGLE_DRIVE" -C "$ZSH_BASH_BASE";
    
    echo ''
    echo ''
    echo '-------------------------------------------------'
    echo 'done'

    echo 'GPG  ....';
    tar -xvzf "$GIT$GPG_GOGLE_DRIVE" -C "$GPG_BASE";
    
    echo ''
    echo ''
    echo '-------------------------------------------------'

    push_repo  

    echo 'done'
    exit 0
} >&2 

function usage {
    echo "Usage: $0 [-h] [-s ${params}]"
    echo
    echo
    exit 1
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
            echo -e "   Choose direction of sync: \e[93mFrom \e[39mGoogle Drive | \e[93mTo \e[39mGoogle Drive on $OS_SYSTEM"
            echo " -s <parameter>"
            echo "   ${params}"
            echo
            usage
            ;;
	    s)
            case "$OPTARG" in
            	to)
                    sync_to                   
                    ;;
                from)
                    sync_from
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
