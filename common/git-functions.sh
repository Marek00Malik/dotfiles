#!/bin/bash
###########################################################################
## This script is contains GIT functions
###########################################################################
params="<download|upload>"




function pull_repo {

    echo "Would you like to pull latest data from origin (${green}Yes${reset}/${blue}No${reset})?"
    read userInput
    echo    # (optional) move to a new line
    if [[ $userInput =~ ^[(Yes|Y|yes|y)]$ ]]
    then    
        echo -e "....................................................."
        echo "Sync local with remote origin."
        echo "Fetch from remote"
        git pull
        echo -e "....................................................."
    fi
}

function push_repo {
    echo "Would you like to push latest data to origin (${green}Yes${reset}/${blue}No${reset})?"
    read userInput
    echo    # (optional) move to a new line
    if [[ $userInput =~ ^[(Yes|Y|yes|y)]$ ]]
    then    
        echo -e "....................................................."

        echo "Sync local with remote origin."
        git add --all
        git commit -m "Backup - changes `date '+%Y/%m/%d %H:%M'` `$OS_SYSTEM`"

        git push origin master

        echo -e "....................................................."
    fi
}