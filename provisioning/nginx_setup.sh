/bin/bash
echo "Provisioning script #6 is running"

# Get the container ID
CONTAINER_ID=$(docker ps -qf "name=dockerconf_zabbix-web_1")

# Create necessary directories
docker cp $CONTAINER_ID:/etc/zabbix/nginx.conf .

# Configure Nginx to serve the Zabbix web interface
sed -i 's/listen 8080;/listen 80;/g' /etc/zabbix/nginx.conf

# Create necessary directories
docker cp ./nginx.conf $CONTAINER_ID:/etc/zabbix/nginx.conf


echo "Nginx configured to serve Zabbix web interface on port 80"
echo "All done"
