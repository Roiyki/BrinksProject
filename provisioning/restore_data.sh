#!/bin/bash

CONTAINER_ID=$(docker ps -qf "name=dockerconf_postgres-server_1")

# Path to the backup file
BACKUP_FILE_PATH=/home/vagrant/backup/backup_file.sql

# Check if the backup file exists
if [ -f "$BACKUP_FILE_PATH" ]; then
    echo "Restoring database from backup..."

    # Run psql command to restore the database
    docker exec "$CONTAINER_ID" psql -U "$POSTGRES_USER" -h localhost -p 5432 -d "$POSTGRES_DB" -f "$BACKUP_FILE_PATH"

    # Check if the restore was successful
    if [ $? -eq 0 ]; then
        echo "Database restore completed successfully."
    else
        echo "Error: Database restore failed!"
        exit 1
    fi
else
    echo "Error: Backup file not found!"
    exit 1
fi