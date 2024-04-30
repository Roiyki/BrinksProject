#!/bin/bash

# Check if the backup file exists
if [ -f /home/vagrant/backup/backup_file.sql ]; then
    echo "Restoring database from backup..."

    # Set the PGPASSWORD environment variable
    export PGPASSWORD=$POSTGRES_PASSWORD
    CONTAINER_ID=$(docker ps -qf "name=dockerconf_postgres-server_1")

    # Drop existing database
    echo "Dropping existing database..."
    docker exec -i $CONTAINER_ID /bin/bash -c "PGPASSWORD=$POSTGRES_PASSWORD dropdb -U $POSTGRES_USER $POSTGRES_DB"

    # Create new database
    echo "Creating new database..."
    docker exec -i $CONTAINER_ID /bin/bash -c "PGPASSWORD=$POSTGRES_PASSWORD createdb -U $POSTGRES_USER $POSTGRES_DB"

    # Restore database from backup
    echo "Restoring database..."
    docker exec -i $CONTAINER_ID /bin/bash -c "PGPASSWORD=$POSTGRES_PASSWORD psql -U $POSTGRES_USER -h localhost -p 5432 -d $POSTGRES_DB" < /home/vagrant/backup/backup_file.sql

    # Check if the restore was successful
    if [ $? -eq 0 ]; then
        echo "Database restore completed successfully."
    else
        echo "Error: Database restore failed!"
        exit 1
    fi

    # Unset the PGPASSWORD environment variable
    unset PGPASSWORD
else
    echo "Error: Backup file not found!"
    exit 1
fi