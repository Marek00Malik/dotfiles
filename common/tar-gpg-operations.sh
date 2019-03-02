#!/bin/bash
###########################################################################
## This script handles TAR and GPG operations. 
###########################################################################

function compress_and_encrypt {
	REMOTE_DEST=$1
	DEST_FILENAME=$2
	DESCRIPTION=$3

	echo  -e "Copping files from $OS_SYSTEM to Google Drive";
    echo ''
    echo ''
    echo "$DESCRIPTION ....."
    echo "FROM $DEST_FILENAME TO $REMOTE_DEST"

    tar -czvf "$REMOTE_DEST" -C "$DEST_FILENAME" .;
    gpg --batch --yes --output "$REMOTE_DEST.gpg" --recipient "info@code-house.pl" --encrypt "$REMOTE_DEST";
    rm "$REMOTE_DEST";

    echo ''
    echo ''
}