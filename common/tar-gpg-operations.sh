#!/bin/bash
###########################################################################
## This script handles TAR and GPG operations. 
###########################################################################

function compress_and_encrypt {
	REMOTE_DEST=$1
	DEST_FILENAME=$2
	
	shift;
	shift;
	OPT_FILES=$@

	echo  -e "Copping files from $OS_SYSTEM to Google Drive";
    echo ''
    echo ''   
	if [ -z "$OPT_FILES" ]; then
		tar -czvf "$REMOTE_DEST" -C "$DEST_FILENAME" .;
	else 
		eval "tar -czvf "$REMOTE_DEST" -C "$DEST_FILENAME" $OPT_FILES";
		 # "$OPT_FILE_5" "$OPT_FILE_6"
	fi

    gpg --batch --yes --output "$REMOTE_DEST.gpg" --recipient "info@code-house.pl" --encrypt "$REMOTE_DEST";
    rm "$REMOTE_DEST";

    echo ''
    echo ''
}