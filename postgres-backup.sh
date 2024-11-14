#!/bin/bash
# Purpose: Simple Backup PostgreSQL database to GCP Bucket
# Author: I Made Ocy Darma Putra <imadeocy@itsecasia.com>

# IMPORTANT! Please looks a head for Enviroment Variable
# GCP_ACCESS_KEY = Access Key from GCP
# GCP_SECRET_KEY = Secret Key from GCP
# WEBHOOK_GOOGLE_CHAT = Webhook from Google Space Chat for notification
# BUCKET_GCP = Your bucket gcp name

# Creating boto file
boto_config="[Credentials]
gs_access_key_id = $GCP_ACCESS_KEY
gs_secret_access_key = $GCP_SECRET_KEY

[Boto]
https_validate_certificates = True

[GSUtil]
content_language = en
default_api_version = 1"

# Save boto file to /root/.boto
echo "$boto_config" > "/root/.boto"

# Location of backup folder for temporary
DATE=$(date +"%Y%m%d")
PATH_FOLDER="/root"
BACKUP_FILE="$PATH_FOLDER/$PROJECTNAME-postgres-$DATE.sql"
FILENAME="$PROJECTNAME-postgres-$DATE.sql"

# Backup the database
PGPASSWORD="$PG_PASS" pg_dumpall -v -U $PG_USER -h $PG_HOST -p $PG_PORT > $BACKUP_FILE

# Upload file to the GCP
gsutil cp $BACKUP_FILE gs://$BUCKET_GCP

# Send notification to your Google Space Chat
message="Backup timescale-postgres *$PROJECTNAME* completed:
- Filename: $FILENAME
- Size: $(du -sh $BACKUP_FILE | awk '{print $1}')
- From Host: $PG_HOST
- Date: $DATE"

curl --silent --output /dev/null -X POST -H "Content-Type: application/json" -d '{
  "text": "'"$message"'"
}' "$WEBHOOK_GOOGLE_CHAT"

# Make sure again for sending a message that all task are completely run
if [ $? -eq 0 ]; then
  echo "All task complete and backup complete."
else
  echo "One of task is error, please check again."
fi
