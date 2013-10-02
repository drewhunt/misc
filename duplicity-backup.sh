#!/bin/bash
# Export some ENV variables so you don't have to type anything
export AWS_ACCESS_KEY_ID=<your-access-key-id>
export AWS_SECRET_ACCESS_KEY=<your-secret-access-key>
export PASSPHRASE=<your-gpg-passphrase>
 
GPG_KEY=<your-gpg-key>
 
# The source of your backup
SOURCE=/
 
# The destination
# Note that the bucket need not exist
# but does need to be unique amongst all
# Amazon S3 users. So, choose wisely.
DEST=s3+http://51degrees_backup
 
duplicity \
    incremental \
    --full-if-older-than 1M \
    --encrypt-key ${GPG_KEY} \
    --sign-key ${GPG_KEY} \
    --include=/etc \
    --include=/home \
    --include=/root \
    --include=/srv \
    --exclude=/** \
    --volsize 250 \
    ${SOURCE} ${DEST}
 
duplicity remove-older-than 6M --force ${DEST}
 
# Reset the ENV variables. Don't need them sitting around
export AWS_ACCESS_KEY_ID=
export AWS_SECRET_ACCESS_KEY=
export PASSPHRASE=
