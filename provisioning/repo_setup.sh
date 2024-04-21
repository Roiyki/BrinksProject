#!/bin/bash
echo "Provisioning script #4 is running"
# setting git repository
if [ ! -d "project" ]; then
    mkdir project
fi
cd ./project
sudo apt install -y git
if [ ! -d "BrinksProject" ]; then
    git clone https://github.com/Roiyki/BrinksProject.git
else
    echo "Directory 'BrinksProject' already exists. Skipping cloning."
fi
cd BrinksProject/dockerconf
ln -s /home/vagrant/local/.env /home/vagrant/project/BrinksProject/dockerconf/.env
# Starting the Docker-Compose
ZABBIX_SERVER_IP=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' dockerconf_zabbix-web_1)
sed -i "s/zabbix-server:.*/zabbix-server:$ZABBIX_SERVER_IP/" docker-compose.yml
docker-compose up -d
!/bin/bash

# Step a: Download and install Zabbix repository
# wget https://repo.zabbix.com/zabbix/6.4/ubuntu/pool/main/z/zabbix-release/zabbix-release_6.4-1+ubuntu20.04_all.deb
# sudo dpkg -i zabbix-release_6.4-1+ubuntu20.04_all.deb
# sudo apt update

# # Step b: Install Zabbix server, frontend, agent
# sudo apt install -y zabbix-server-pgsql zabbix-frontend-php php7.4-pgsql zabbix-nginx-conf zabbix-sql-scripts zabbix-agent

# # Step c: Create initial database
# echo "Creating initial database user..."
# echo $POSTGRES_PASSWORD | sudo -u postgres createuser --pwprompt $POSTGRES_USER

# # Create initial database
# echo "Creating initial database..."
# sudo -u postgres createdb -O $POSTGRES_USER $POSTGRES_DB

# # Import initial schema and data
# echo "Importing initial schema and data..."
# zcat /usr/share/zabbix-sql-scripts/postgresql/server.sql.gz | sudo -u $POSTGRES_USER psql $POSTGRES_DB

# # Step d: Configure the database for Zabbix server
# echo "Configuring database for Zabbix server..."
# sudo echo "DBPassword=$POSTGRES_PASSWORD" >> /etc/zabbix/zabbix_server.conf

# # Step e: Configure PHP for Zabbix frontend
# echo "Configuring PHP for Zabbix frontend..."
# sed -i 's/# listen 8080;/listen 8080;/' /etc/zabbix/nginx.conf
# sed -i 's/# server_name example.com;/server_name 192.168.50.10;/' /etc/zabbix/nginx.conf

# # Step f: Start Zabbix server and agent processes
# echo "Starting Zabbix server and agent processes..."
# sudo systemctl restart zabbix-server zabbix-agent nginx php7.4-fpm
# sudo systemctl enable zabbix-server zabbix-agent nginx php7.4-fpm

# echo "Zabbix installation and configuration completed."