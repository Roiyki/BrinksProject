#!/bin/bash
echo "Provisioning script #2 is running"

sudo mkdir -p /var/lib/docker/volumes/postgresql-data/
sudo mkdir -p /var/lib/docker/volumes/zabbix-server-data/
sudo mkdir -p /var/lib/docker/volumes/zabbix-export-data/
sudo mkdir -p /var/lib/docker/volumes/zabbix-web-data/
sudo mkdir -p /var/lib/docker/volumes/grafana-storage/