
# AWS S3 Backup

This script will rsync a set of files and directories into a given backup location.  The backup location will have a folder for the date of the backup snapshot.  A configurable number of backups will be kept, the rest deleted.  After backup copy is made, the contents are synced into S3.


## Setup

This assumes AWS CLI v2 is already installed.  And, account credentials are kept in the appropriate aws client location.

```bash
# Verify the AWS user
aws iam get-user
```

1. Create an S3 Bucket for where the backup content will live.  For example, make a bucket named after the host of this machine:  `aws s3 mb s3://$(hostname)`

2. Make a config file:
```bash
ENV_FILE=${HOME}/.awss3syncenv

if [ ! -f "$ENV_FILE" ]; then
echo -e "Creating AWS S3 Backup config file in $ENV_FILE"
cat <<EOF > $ENV_FILE
# List of directories to be backed up, ie: /some/path1 /some/path2
backup_files="${HOME}/path1 ${HOME}/path2"

# Back ups to be synced to S3 will be store in here.
dest="${HOME}/s3_synced_backup"

# The number of backups to keep
keep=3

# Name of the S3 bucket holding the backup
bucket_name=$(hostname)
EOF
fi
```


## Execute

Execute the backup with:
```bash
./run_backup.sh
```
