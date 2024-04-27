#!/bin/bash

CONTAINER_NAME="dockerconf_postgres-server_1"  # Update with your container name
BACKUP_DIR="/home/vagrant/backup"             # Update with your desired backup directory

# Check if the container is running
if docker ps -f "name=$CONTAINER_NAME" --format '{{.Names}}' | grep -q "^$CONTAINER_NAME$"; then
    echo "Container $CONTAINER_NAME is running..."

    # Stop the PostgreSQL container to ensure consistent backup
    echo "Stopping container $CONTAINER_NAME..."
    docker stop $CONTAINER_NAME

    # Copy the data directory from the container to the host
    echo "Copying data directory from container $CONTAINER_NAME..."
    docker cp $CONTAINER_NAME:/var/lib/postgresql/data $BACKUP_DIR

    # Start the PostgreSQL container
    echo "Starting container $CONTAINER_NAME..."
    docker start $CONTAINER_NAME

    echo "Data directory copied successfully to $BACKUP_DIR"
else
    echo "Error: Container $CONTAINER_NAME is not running."
    exit 1
fi