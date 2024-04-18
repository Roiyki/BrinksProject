#!/bin/bash
# echo "Provisioning script #5 is running"
# # Wait for PostgreSQL container to initialize (adjust sleep time as needed)
# sleep 60
# echo "running posstgres credentials validation"

# #Creating a pgcrypto extension for my postgresql password and altering it
# docker exec $(docker ps -qf "name=dockerconf_postgres-server_1") psql -U $POSTGRES_USER -d zabbix -c "CREATE EXTENSION IF NOT EXISTS pgcrypto;
# ALTER USER $POSTGRES_USER PASSWORD '$POSTGRES_PASSWORD' VALID UNTIL 'infinity';"        

# echo "running changes in postgres authentication"


# #Copying from my database the file that determines the user that is allowed to sign into the database and the login protocol
# docker cp $(docker ps -qf "name=postgres-server"):/var/lib/postgresql/data/pg_hba.conf ~/pg_hba.conf

# # Modify pg_hba.conf file to use "trust" authentication to allow my user
# sed -i '$ s/scram-sha-256/trust/' ~/pg_hba.conf

# # Copy pg_hba.conf file back to the container after changing it
# CONTAINER_ID=$(docker ps -qf "name=dockerconf_postgres-server_1")
# docker cp ~/pg_hba.conf $CONTAINER_ID:/var/lib/postgresql/data/pg_hba.conf
# echo "restarting postgres container"

# # Restart the PostgreSQL container to apply changes
# docker restart $CONTAINER_ID
# Step a: Install PostgreSQL
echo "Installing PostgreSQL..."
sudo apt update
sudo apt install -y postgresql

# Step b: Create PostgreSQL user and database
# echo "Creating PostgreSQL user and database..."
# sudo -u postgres createuser --pwprompt $POSTGRES_USER || { echo "Failed to create PostgreSQL user."; exit 1; }
# sudo -u postgres createdb -O $POSTGRES_USER $POSTGRES_DB || { echo "Failed to create PostgreSQL database."; exit 1; }

# Step c: Configure PostgreSQL authentication
echo "Configuring PostgreSQL authentication..."
# You might want to adjust the authentication method based on your security requirements
# For example, to allow password authentication for all users from all addresses:
sudo echo "host    all             all             0.0.0.0/0            md5" >> /etc/postgresql/<version>/main/pg_hba.conf

# Step d: Restart PostgreSQL service
echo "Restarting PostgreSQL service..."
sudo systemctl restart postgresql.service

echo "PostgreSQL installation and configuration completed successfully."