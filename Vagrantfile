# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/xenial64"

  #nginx
  config.vm.network :forwarded_port, guest: 80, host: 8888

  #MySQL
  config.vm.network :forwarded_port, guest: 3306, host: 3306

  config.vm.provision :shell, path: "vagrant_bootstrap/bootstrap.sh"
end
