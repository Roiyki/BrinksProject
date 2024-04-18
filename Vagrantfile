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
    server.vm.network "forwarded_port", guest: 8090, host: 8888
    server.vm.network "forwarded_port", guest: 3000, host: 3000
    server.vm.network "private_network", ip: "192.168.50.10"
    # Creating linked directories between docker volumes and local directories
    server.vm.synced_folder ".", "/home/vagrant/local"
    server.vm.synced_folder "C:/Brinks/Volumes/postgres", "/var/lib/docker/volumes/postgres/"
    server.vm.synced_folder "C:/Brinks/Volumes/zabbix", "/var/lib/docker/volumes/zabbix/"
    server.vm.synced_folder "C:/Brinks/Volumes/graf_data", "/var/lib/docker/volumes/graf_data/"
    server.vm.synced_folder "C:/Brinks/Volumes/graf_config", "/var/lib/docker/volumes/graf_config/"
    # Starting the provisioning commands
  config.vm.provision "shell", path: "provisioning/variables_load.sh"
  config.vm.provision :reload
  config.vm.provision "shell", path: "provisioning/volume_dirs.sh"
  config.vm.provision "shell", path: "provisioning/docker.sh"
  config.vm.provision "shell", path: "provisioning/repo_setup.sh"
  # config.vm.provision "shell", path: "provisioning/postgres_setup.sh"
  # config.vm.provision "shell", path: "provisioning/nginx_setup.sh"
  end

  # Zabbix Agent VM
  config.vm.define "zabbix-agent" do |agent|
    agent.vm.box = "ubuntu/bionic64"
    # Configure memory, CPU, and other settings for the agent VM
    agent.vm.network "private_network", ip: "192.168.50.11"

    agent.vm.provision "shell", inline: <<-SHELL
      # Install Zabbix Agent and configure it to send metrics to the Zabbix Server VM
    SHELL
  end
end