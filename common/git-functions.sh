#!/bin/bash
###########################################################################
## This script is contains GIT functions
###########################################################################
params="<download|upload>"




function pull_repo {

    read -p "Would you like to pull latest data from origin (Yes/No)?" -n 1 -r
    echo    # (optional) move to a new line
    if [[ $REPLY =~ ^[(Yes|Y|yes|y)]$ ]]
    then    
        echo -e "....................................................."
        echo "Sync local with remote origin."
        echo "Fetch from remote"
        git pull
        echo -e "....................................................."
    fi
}

function push_repo {
    read -p "Would you like to push latest data to origin (Yes/No)?" -n 1 -r
    echo    # (optional) move to a new line
    if [[ $REPLY =~ ^[(Yes|Y|yes|y)]$ ]]
    then    
        echo -e "....................................................."

        echo "Sync local with remote origin."
        git add --all
        git commit -m "Backup - changes `date '+%Y/%m/%d %H:%M'` `$OS_SYSTEM`"

        git push origin master

        echo -e "....................................................."
    fi
}