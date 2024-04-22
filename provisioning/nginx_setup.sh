/bin/bash
echo "Provisioning script #6 is running"

# Get the container ID
CONTAINER_ID=$(docker ps -qf "name=dockerconf_zabbix-web_1")

# Create necessary directories

# Configure Nginx to serve the Zabbix web interface
docker exec $CONTAINER_ID sed -i 's/listen 8080;/listen 80;/g' /etc/zabbix/nginx.conf

# Create necessary directories
docker exec $CONTAINER_ID nginx -s reload 
sed -i "s/zabbix-server:.*/zabbix-server:$ZABBIX_SERVER_IP/" docker-compose.yml

echo "Nginx configured to serve Zabbix web interface on port 80"
echo "All done"
