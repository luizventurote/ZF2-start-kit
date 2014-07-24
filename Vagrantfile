Vagrant.configure("2") do |config|

  # Box
  config.vm.box = "hashicorp/precise64"
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"

  # Network
  config.vm.network "forwarded_port", guest: 80, host: 8080
  config.vm.network "private_network", ip: "192.168.33.10"

  # Sync folders
  config.vm.synced_folder "www", "/var/www/html", create: true

end