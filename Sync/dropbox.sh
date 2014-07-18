#!/bin/bash
#
# Start editing here.
DROPBOX_USER="zyxfsky@gmail.com"
DROPBOX_PASS="*"
DROPBOX_DIR="/vps-backups-sql"
nowtime=`date +%Y%m%d -d "-1 day"`
Backup_file="/home/www/dbbackup/sql-$nowtime.tar.gz"

# Upload a file to Dropbox.
# $1 = Source file
# $2 = Destination file.
function dropboxUpload
{
        # Initiate
        LOGIN_URL="https://www.dropbox.com/login"
        HOME_URL="https://www.dropbox.com/home"
        UPLOAD_URL="https://dl-web.dropbox.com/upload"
        COOKIE_FILE="/tmp/du_cookie_$RANDOM"
        RESPONSE_FILE="/tmp/du_resp_$RANDOM"

    UPLOAD_FILE=$1
    DEST_FOLDER=$2

        # Login
        echo -ne " > Logging in Your Dropbox Account ..."
        curl -s -i -c $COOKIE_FILE -o $RESPONSE_FILE --data "login_email=$DROPBOX_USER&login_password=$DROPBOX_PASS&t=$TOKEN" "$LOGIN_URL"
        grep "location: /home" $RESPONSE_FILE > /dev/null
        echo -e " "

        # Load home page
        echo -ne " > Loading Your Dropbox Home Directory ..."
        curl -s -i -b "$COOKIE_FILE" -o "$RESPONSE_FILE" "$HOME_URL"
        echo -e " "

        # Get token
        TOKEN=$(cat "$RESPONSE_FILE" | tr -d '\n' | sed 's/.*<form action="https:\/\/dl-web.dropbox.com\/upload"[^>]*>\s*<input type="hidden" name="t" value="\([a-z 0-9]*\)".*/\1/')

        # Upload file
        echo -ne " > Uploading '$UPLOAD_FILE' to 'Dropbox$DEST_FOLDER/' ..."
    curl -s -i -b $COOKIE_FILE -o $RESPONSE_FILE -F "plain=yes" -F "dest=$DEST_FOLDER" -F "t=$TOKEN" -F "file=@$UPLOAD_FILE"  "$UPLOAD_URL"
    grep "HTTP/1.1 302 FOUND" "$RESPONSE_FILE" > /dev/null
        rm -f "$COOKIE_FILE" "$RESPONSE_FILE"
        echo -e " "
}

dropboxUpload "$Backup_file" "$DROPBOX_DIR"
