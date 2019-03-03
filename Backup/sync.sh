#!/bin/bash
###########################################################################
## This script is responsible for syncing idea configs between enviroments Linux and MacOs to Google Drive cloud.
###########################################################################

source "../common/git-functions.sh"
source "../common/tar-gpg-operations.sh"

set -e
SSH_REMOTE='/ssh_config';
SSH_LINUX="$HOME/.ssh/";
SSH_OS="$HOME/.ssh";

ZSH_BASH_REMOTE='/zsh_bash';
ZSH_BASH_LINUX="$HOME";
ZSH_BASH_OS="$HOME";

WORK_REMOTE='/work';
WORK_LINUX="$HOME/Dokumenty/WORK/projects/";
WORK_OS="$HOME/Documents/WORK/projects/";

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
    echo '-------------------------------------------------'
    echo
    echo

    echo 'SSH CONFIGS' 
    compress_and_encrypt "$GIT$SSH_REMOTE" "$SSH_BASE";

    echo 'ZSH and BASH CONFIGS'
	compress_and_encrypt "$GIT$ZSH_BASH_REMOTE" "$ZSH_BASH_BASE" "'.zshrc' '.bashrc' '.bash_aliases' '.bash_profile'" ;

    echo 'WORK DOCUMENTATION'
    compress_and_encrypt "$GIT$WORK_REMOTE" "$WORK_BASE";

    echo 
    echo
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
    decompose_and_decrypt "$GIT$SSH_REMOTE" "$SSH_BASE";
    echo ''
    echo ''


    echo 'ZSH and BASH CONFIGS  ....';
    decompose_and_decrypt "$GIT$ZSH_BASH_REMOTE" "$ZSH_BASH_BASE";
    echo ''
    echo ''
    
    echo 'WORK DOCUMENTATION'
    decompose_and_decrypt "$GIT$WORK_REMOTE" "$WORK_BASE";
    echo ''
    echo ''
    echo '-------------------------------------------------'

    echo 'done'

    exit 0
} >&2 

. ../common/main_menu.sh
