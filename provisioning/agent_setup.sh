
# Add Zabbix repository
wget https://repo.zabbix.com/zabbix/6.4/ubuntu/pool/main/z/zabbix-release/zabbix-release_6.4-1+ubuntu20.04_all.deb
sudo dpkg -i zabbix-release_6.4-1+ubuntu20.04_all.deb

# Update package repository
sudo apt update

# Install Zabbix Agent and plugins
sudo apt install zabbix-agent2 zabbix-agent2-plugin-*

# Extract Container ID
CONTAINER_ID=$(docker ps -qf "name=dockerconf_zabbix-server_1")

# Update Zabbix Server Configuration
sudo sed -i "s/Server=*/Server=127.0.0.1,$CONTAINER_ID/g" /etc/zabbix/zabbix_agentd.conf

#Restart zabbix agent to read changes in the configuration
sudo systemctl restart zabbix-agent2