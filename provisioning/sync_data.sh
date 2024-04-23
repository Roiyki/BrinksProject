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
vagrant ssh -c "sudo rsync -av /var/lib/docker/volumes/postgresql-data/ C:/Brinks/Volumes/postgre"
vagrant ssh -c "sudo rsync -av /var/lib/docker/volumes/zabbix-server-data/ C:/Brinks/Volumes/zabbix"
vagrant ssh -c "sudo rsync -av /var/lib/docker/volumes/zabbix-export-data/ C:/Brinks/Volumes/zabbix-export"
vagrant ssh -c "sudo rsync -av /var/lib/docker/volumes/zabbix-web-data/ C:/Brinks/Volumes/zabbix-web"
vagrant ssh -c "sudo rsync -av /var/lib/docker/volumes/grafana-storage/ C:/Brinks/Volumes/grafana"

if [ $? -eq 0 ]; then
    echo "Data synced successfully."
else
    echo "Error: Data sync failed."
fi