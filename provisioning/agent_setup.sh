#!/bin/bash
# Add Zabbix repository
wget https://repo.zabbix.com/zabbix/6.4/ubuntu/pool/main/z/zabbix-release/zabbix-release_6.4-1+ubuntu20.04_all.deb
sudo dpkg -i zabbix-release_6.4-1+ubuntu20.04_all.deb

# Update package repository
sudo apt update

# Install Zabbix Agent and plugins
sudo apt install zabbix-agent2 zabbix-agent2-plugin-*

# Extract Container IP
CONTAINER_NAME_SERVER="dockerconf_zabbix-server_1"
CONTAINER_IP_SERVER=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $CONTAINER_NAME_SERVER)

CONTAINER_NAME_WEB="dockerconf_zabbix-web_1"
CONTAINER_IP_WEB=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $CONTAINER_NAME_WEB)
# Update Zabbix Server Configuration
sudo sed -i '133s/^Server=.*/Server=127.0.0.1,'"$CONTAINER_IP_WEB"','"$CONTAINER_IP_SERVER"'/' /etc/zabbix/zabbix_agent2.conf

#Restart zabbix agent to read changes in the configuration
sudo systemctl restart zabbix-agent2