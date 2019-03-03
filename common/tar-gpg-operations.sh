#!/bin/bash
###########################################################################
## This script handles TAR and GPG operations. 
###########################################################################

function compress_and_encrypt {
	REMOTE_FILENAME=$1
	LOCAL_FILENAME=$2
	
	shift;
	shift;
	OPT_FILES=$1

    echo ''
    echo ''   
	if [ -z "$OPT_FILES" ]; then
		tar -czvf "$REMOTE_FILENAME.tar.gz" -C "$LOCAL_FILENAME" .;
	else 
		eval "tar -czvf "$REMOTE_FILENAME.tar.gz" -C "$LOCAL_FILENAME" $OPT_FILES";
	fi

    gpg --batch --yes --output "$REMOTE_FILENAME.gpg" --recipient "info@code-house.pl" --encrypt "$REMOTE_FILENAME.tar.gz";
    rm "$REMOTE_FILENAME.tar.gz";

    echo ''
    echo ''
}

#REMOTE_FILENAME should be passed only without any exctensions
function decompress_and_decrypt {
	REMOTE_FILENAME=$1
	LOCAL_DIR=$2

	echo ''
    echo ''
    if [[ ! -d "$LOCAL_DIR" ]]; then
        echo "CREATING DIR: $LOCAL_DIR"
        mkdir -p "$LOCAL_DIR"
    fi
    gpg --batch --yes --output "$REMOTE_FILENAME.tar.gz" --decrypt "$REMOTE_FILENAME.tar.gz.gpg";
    tar -xvzf "$REMOTE_FILENAME.tar.gz" -C "$LOCAL_DIR";
    rm "$REMOTE_FILENAME.tar.gz";

    echo ''
    echo ''
}