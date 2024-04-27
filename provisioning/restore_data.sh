#!/bin/bash

# Check if the backup directory exists
if [ -d /home/vagrant/backup/data ]; then
    echo "Restoring database from backup..."

    # Set the PGPASSWORD environment variable
    export PGPASSWORD=$POSTGRES_PASSWORD

    CONTAINER_NAME="dockerconf_postgres-server_1"  # Update with your container name

    # Stop the PostgreSQL container to ensure a consistent restore
    echo "Stopping container $CONTAINER_NAME..."
    docker stop $CONTAINER_NAME

    # Copy the data directory from the backup to the container
    echo "Copying data directory to container $CONTAINER_NAME..."
    docker cp /home/vagrant/backup/data $CONTAINER_NAME:/var/lib/postgresql

    # Start the PostgreSQL container
    echo "Starting container $CONTAINER_NAME..."
    docker start $CONTAINER_NAME

    echo "Database restore completed successfully."
    # Unset the PGPASSWORD environment variable
    unset PGPASSWORD
else
    echo "Error: Backup directory not found!"
    exit 1
fi