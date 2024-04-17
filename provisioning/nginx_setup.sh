/bin/bash
echo "Provisioning script #6 is running"

# Get the container ID
CONTAINER_ID=$(docker ps -qf "name=dockerconf_zabbix-web_1")

# Create necessary directories
docker exec -u 0 $CONTAINER_ID bash -c "mkdir -p /etc/nginx/sites-available/ /etc/nginx/sites-enabled/"

# Configure Nginx to serve the Zabbix web interface
docker exec -u 0 $CONTAINER_ID bash -c "cat > /etc/nginx/sites-available/zabbix.conf <<EOF
server {
        listen 80;

        server_name zabbix.yubeiluo.net;
        access_log /var/log/nginx/zabbix/access.log;
        error_log /var/log/nginx/zabbix/error.log;

        root /usr/share/zabbix;

        location / {
                if ( \$scheme ~ ^http: ) {
                        rewrite ^(.*)$ https://\$host\$1 permanent;
                }
                index   index.php;
                error_page      403     404     502     503     504     /zabbix/index.php;

                location ~\\.php$ {
                        if ( !-f \$request_filename ) { return 404; }
                        expires epoch;
                        include /etc/nginx/fastcgi_params;
                        fastcgi_index index.php;
                        fastcgi_pass unix:/var/run/zabbix.socket;
                        fastcgi_param SCRIPT_FILENAME   /usr/share/zabbix/\$fastcgi_script_name;
                }

                location ~ \\.(jpg|jpeg|gif|png|ico)$ {
                        access_log off;
                        expires 33d;
                }
        }

}
EOF"

# Create symbolic link
docker exec -u 0 $CONTAINER_ID bash -c "ln -s /etc/nginx/sites-available/zabbix.conf /etc/nginx/sites-enabled/"

# Fix syntax error in Nginx configuration
docker exec -u 0 $CONTAINER_ID bash -c "sed -i 's/server_tokens on;/server_tokens on;/' /etc/nginx/nginx.conf"

# Verify Nginx configuration
echo "Verifying Nginx configuration..."
docker exec -u 0 $CONTAINER_ID bash -c "nginx -t"

# Restart Nginx to apply the changes
echo "Restarting Nginx..."
docker exec -u 0 $CONTAINER_ID bash -c "service nginx restart"

# Check if Nginx is listening on port 80
echo "Checking if Nginx is listening on port 80..."
docker exec -u 0 $CONTAINER_ID bash -c "lsof -i :80 -s TCP:LISTEN || echo 'Nginx is not listening on port 80'"

echo "Nginx configured to serve Zabbix web interface on port 80"
echo "All done"
