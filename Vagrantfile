Vagrant.configure("2") do |config|
  config.vm.boot_timeout = 600

  config.vm.provider "virtualbox" do |vb|
    vb.customize ["modifyvm", :id, "--cableconnected1", "on"]
    vb.customize ['modifyvm', :id, '--graphicscontroller', 'vmsvga']
    vb.gui = false
    vb.memory = "2048"
    vb.cpus = 4
  end

  # Zabbix Server VM
  config.vm.define "zabbix-server" do |server|
    server.vm.box = "ubuntu/focal64"
    # Configuring networking settings
    server.vm.network "forwarded_port", guest: 8080, host: 8090
    server.vm.network "forwarded_port", guest: 80, host: 8888
    server.vm.network "forwarded_port", guest: 3000, host: 3000
    server.vm.network "forwarded_port", guest: 10051, host: 10051
    server.vm.network "forwarded_port", guest: 10050, host: 10050 
    server.vm.network "forwarded_port", guest: 5432, host: 5432
    server.vm.network "private_network", ip: "192.168.50.10"
    # Creating linked directories between docker volumes and local directories
    server.vm.synced_folder ".", "/home/vagrant/local"
    server.vm.synced_folder "C:/Brinks/Volumes/postgres", "/var/lib/docker/volumes/postgres/"
    server.vm.synced_folder "C:/Brinks/Volumes/zabbix", "/var/lib/docker/volumes/zabbix/"
    server.vm.synced_folder "C:/Brinks/Volumes/graf_data", "/var/lib/docker/volumes/graf_data/"
    server.vm.synced_folder "C:/Brinks/Volumes/graf_config", "/var/lib/docker/volumes/graf_config/"
    # Starting the provisioning commands
  # config.vm.provision "shell", path: "provisioning/variables_load.sh"
  # config.vm.provision :reload
  # config.vm.provision "shell", path: "provisioning/volume_dirs.sh"
  # config.vm.provision "shell", path: "provisioning/docker.sh"
  # config.vm.provision "shell", path: "provisioning/repo_setup.sh"
  # config.vm.provision "shell", path: "provisioning/nginx_setup.sh"
  config.vm.provision "shell", path: "provisioning/agent_setup.sh"
  end
end