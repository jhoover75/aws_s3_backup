#!/bin/bash

# ENV file holding application state
ENV_FILE=${HOME}/.awss3syncenv

# Reading in environment variables from file.  https://stackoverflow.com/questions/19331497/set-environment-variables-from-file-of-key-value-pairs/30969768#30969768
set -o allexport; source $ENV_FILE; set +o allexport

echo -e "Staging backups to local directory: $dest"
#env | sort

# Directory name to hold backups from this script run
day=$(date +%Y_%m_%d_%s)

# Full path to where backed up files will be kept locally.
archive_dir="$dest/$day"

# Print start status message.
echo "Backing up $backup_files to $archive_dir"

# Making the backup directory
mkdir -p $archive_dir > /dev/null

# Making local copy of items to be backed up.
rsync -ah $backup_files $archive_dir --exclude '$dest'

# Keeping N number of backup directories, deleting the rest
while [ `ls "$dest" | wc -w` -gt $keep ]; do
    oldest=`ls "$dest" | head -1`
    echo "removing $dest/$oldest"
    rm -rf "$dest/$oldest"
done


# Synching to S3
aws s3 mb s3://${bucket_name}
aws s3 sync --delete --storage-class GLACIER "$dest" s3://${bucket_name}


