#!/bin/bash

ensure_directory_exists() {
    if [ ! -d "$1" ]; then
        mkdir -p "$1"
    fi
}
echo "Syncing data from VM to host machine..."

ensure_directory_exists "C:/Brinks/Volumes/postgre"
ensure_directory_exists "C:/Brinks/Volumes/zabbix"
ensure_directory_exists "C:/Brinks/Volumes/zabbix-export"
ensure_directory_exists "C:/Brinks/Volumes/zabbix-web"
ensure_directory_exists "C:/Brinks/Volumes/grafana"
# Sync data from VM to host machine
sudo rsync -av /var/lib/docker/volumes/postgresql-data/ /vagrant/postgre
sudo rsync -av /var/lib/docker/volumes/zabbix-server-data/ /vagrant/zabbix
sudo rsync -av /var/lib/docker/volumes/zabbix-export-data/ /vagrant/zabbix-export
sudo rsync -av /var/lib/docker/volumes/zabbix-web-data/ /vagrant/zabbix-web
sudo rsync -av /var/lib/docker/volumes/grafana-storage/ /vagrant/grafana


if [ $? -eq 0 ]; then
    echo "Data synced successfully."
else
    echo "Error: Data sync failed."
fi