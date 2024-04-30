#!/bin/bash

CONTAINER_ID=$(docker ps -qf "name=dockerconf_postgres-server_1")

# Check if the backup file exists
if [ -f /home/vagrant/backup/backup_file.sql ]; then
    echo "Creating database backup..."

    # Export the PGPASSWORD variable for authentication
    export PGPASSWORD=$POSTGRES_PASSWORD

    # Get the IP address of the container
    CONTAINER_IP=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $CONTAINER_ID)

    # Run pg_dump command inside the container to create the database backup
    echo "$PGPASSWORD" | docker exec -i $CONTAINER_ID pg_dump -U $POSTGRES_USER -h $CONTAINER_IP -p 5432 -d $POSTGRES_DB > /home/vagrant/backup/backup_file.sql

    # Check if the backup was successful
    if [ $? -eq 0 ]; then
        echo "Database backup completed successfully."
    else
        echo "Error: Database backup failed!"
        exit 1
    fi

    # Unset the PGPASSWORD variable
    unset PGPASSWORD
else
    echo "Error: Backup file not found!"
    exit 1
fi