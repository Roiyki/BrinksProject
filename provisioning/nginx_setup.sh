#!/bin/bash
echo "Provisioning script #5 is running"

# Get the container ID
CONTAINER_ID=$(docker ps -qf "name=dockerconf_zabbix-web_1")

# Step 1: Copy the Nginx configuration file from the container
docker cp $CONTAINER_ID:/etc/zabbix/nginx.conf nginx.conf

# Step 2: Modify the Nginx configuration file
sed -i 's/listen 8080;/listen 80;/g' nginx.conf

# Step 3: Copy the modified Nginx configuration file back to the container
docker cp nginx.conf $CONTAINER_ID:/etc/zabbix/nginx.conf

# Step 4: Reload Nginx inside the container
docker exec -u 0 $CONTAINER_ID nginx -s reload

echo "Nginx configured to serve Zabbix web interface on port 80"
echo "All done"
