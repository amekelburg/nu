# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # Use Ubuntu 14.04 Trusty Tahr 64-bit as our operating system
  config.vm.box = "ubuntu/trusty64"

  # Configurate the virtual machine to use 2GB of RAM
  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", "1024"]
  end

  # Forward the Rails server default port to the host
  config.vm.network :forwarded_port, guest: 3000, host: 3000

  config.vm.provision :shell, path: 'bootstrap.sh', keep_color: true
  
  # Use Chef Solo to provision our virtual machine
  # config.vm.provision :chef_solo do |chef|
  #   chef.cookbooks_path = ["cookbooks", "cookbooks-site"]
  #
  #   chef.add_recipe "apt"
  #   # chef.add_recipe "nodejs"
  #   # chef.add_recipe "ruby_build"
  #   chef.add_recipe "nu"
  #
  #   # Install Ruby 2.2.1 and Bundler
  #   # Set an empty root password for MySQL to make things simple
  #   chef.json = {
  #     'rvm' => {
  #       #'installer_url' => 'https://raw.github.com/wayneeseguin/rvm/master/binscripts/rvm-installer',
  #       #'branch' => 'none',
  #       #'version' => '1.17.10',
  #       rubies: ['2.1.3'],
  #       default_ruby: '2.1.3',
  #       :global_gems => [
  #       {:name => 'bundler'}]
  # }  }
  # end
end