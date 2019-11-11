#!/bin/bash
###########################################################################
## This script is responsible for syncing idea configs between enviroments Linux and MacOs to Google Drive cloud.
###########################################################################

source "${BASH_SOURCE%/*}/../common/git-functions.sh"
source "${BASH_SOURCE%/*}/../common/tar-gpg-operations.sh"


set -e
SSH_REMOTE_FILENAMEE='/ssh_config';
SSH_LINUX_DIR="$HOME/.ssh/";
SSH_OSX_DIR="$HOME/.ssh";

ZSH_BASH_REMOTE_FILENAME='/zsh_bash';
ZSH_BASH_LINUX_DIR="$HOME";
ZSH_BASH_OSX_DIR="$HOME";

OS_SYSTEM='unknown'

if [[ $OSTYPE == "Linux" ]]; then
    OS_SYSTEM='Linux'
    GIT="$HOME/Desktop/GitCode/Personal/dotfiles/Backup"
    SSH_DIR="$SSH_LINUX_DIR"
    ZSH_BASH_DIR="$ZSH_BASH_LINUX_DIR" 
elif [[ "$(uname -s)" == 'Darwin' ]]; then
    OS_SYSTEM='MacOs'   
    GIT="$HOME/Desktop/GitCode/Personal/dotfiles/Backup"  
    SSH_DIR="$SSH_OSX_DIR"
    ZSH_BASH_DIR="$ZSH_BASH_OSX_DIR"  
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
    compress_and_encrypt "$GIT$SSH_REMOTE_FILENAMEE" "$SSH_DIR";

    echo 'ZSH and BASH CONFIGS'
	compress_and_encrypt "$GIT$ZSH_BASH_REMOTE_FILENAME" "$ZSH_BASH_DIR" "'.zshrc' '.bashrc' '.bash_aliases' '.bash_profile'" ;

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
    decompress_and_decrypt "$GIT$SSH_REMOTE_FILENAMEE" "$SSH_DIR";
    echo ''
    echo ''


    echo 'ZSH and BASH CONFIGS  ....';
    decompress_and_decrypt "$GIT$ZSH_BASH_REMOTE_FILENAME" "$ZSH_BASH_DIR";
    echo ''
    echo ''
    echo '-------------------------------------------------'

    echo 'done'

    exit 0
} >&2 

source "${BASH_SOURCE%/*}/../common/main_menu.sh"
