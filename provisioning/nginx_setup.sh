#!/bin/bash

# Copy nginx.conf from the container to a local file
docker cp 7705cbe28b40:/etc/nginx/nginx.conf ~/nginx_copy.conf

# Add the server block to the copied nginx.conf file
cat <<EOT >> ~/nginx_copy.conf

# Add inside the http block
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
EOT

# Copy the modified nginx.conf back to the container
docker cp ~/nginx_copy.conf 7705cbe28b40:/etc/nginx/nginx.conf

# Restart the container to apply the changes
docker restart 7705cbe28b40