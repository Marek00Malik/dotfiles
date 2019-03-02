#!/bin/bash
###########################################################################
## This script is contains GIT functions
###########################################################################

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