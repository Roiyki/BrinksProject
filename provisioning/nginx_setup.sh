#!/bin/bash
echo "Provisioning script #6 is running"

# Get the container ID
CONTAINER_ID=$(docker ps -qf "name=dockerconf_zabbix-web_1")

# Execute commands inside the Docker container with root privileges
docker exec -u 0 $CONTAINER_ID bash -c "export DEBIAN_FRONTEND=noninteractive && apt-get update && apt-get install -y nginx-full && nginx -g 'daemon off;'"

# Resolve dependency issues with Nginx and Zabbix
docker exec -u 0 $CONTAINER_ID bash -c "export DEBIAN_FRONTEND=noninteractive && apt-get purge nginx nginx-common nginx-core nginx-full && apt-get install -y nginx"

# Configure Nginx to serve the Zabbix web interface
docker exec -u 0 $CONTAINER_ID bash -c "cat > /etc/nginx/sites-available/zabbix.conf <<EOF
server {
    listen 80;
    server_name _;

    root /usr/share/zabbix;
    index index.php index.html index.htm;

    location / {
        try_files \$uri \$uri/ /index.php?\$args;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php7.4-fpm.sock;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        include fastcgi_params;
    }
}
EOF"

# Copy the Zabbix configuration file to the sites-enabled directory
docker exec -u 0 $CONTAINER_ID bash -c "ln -s /etc/nginx/sites-available/zabbix.conf /etc/nginx/sites-enabled/"

# Comment out unsupported configuration in Nginx
docker exec -u 0 $CONTAINER_ID bash -c "sed -i 's/aio on;/# aio on;/' /etc/nginx/nginx.conf"

# Verify Nginx configuration
echo "Verifying Nginx configuration..."
docker exec -u 0 $CONTAINER_ID bash -c "nginx -t"

# Restart Nginx to apply the changes
echo "Restarting Nginx..."
docker exec $CONTAINER_ID bash -c "service nginx restart"

# Check if Nginx is listening on port 80
echo "Checking if Nginx is listening on port 80..."
docker exec $CONTAINER_ID bash -c "lsof -i :80 -s TCP:LISTEN || echo 'Nginx is not listening on port 80'"

echo "Nginx configured to serve Zabbix web interface on port 80"
echo "All done"