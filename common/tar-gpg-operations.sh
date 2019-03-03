#!/bin/bash
###########################################################################
## This script handles TAR and GPG operations. 
###########################################################################

function compress_and_encrypt {
	REMOTE_DEST=$1
	DEST_FILENAME=$2
	
	shift;
	shift;
	OPT_FILE_1=$1
	OPT_FILE_2=$2
	OPT_FILE_3=$3
	OPT_FILE_4=$4
	# OPT_FILE_5=$5
	# OPT_FILE_6=$6


	echo  -e "Copping files from $OS_SYSTEM to Google Drive";
    echo ''
    echo ''   
	if [ -z "$OPT_FILE_1" ]; then
		tar -czvf "$REMOTE_DEST" -C "$DEST_FILENAME" .;
	else 
		tar -czvf "$REMOTE_DEST" -C "$DEST_FILENAME" "$OPT_FILE_1" "$OPT_FILE_2" "$OPT_FILE_3" "$OPT_FILE_4";
		 # "$OPT_FILE_5" "$OPT_FILE_6"
	fi

    gpg --batch --yes --output "$REMOTE_DEST.gpg" --recipient "info@code-house.pl" --encrypt "$REMOTE_DEST";
    rm "$REMOTE_DEST";

    echo ''
    echo ''
}