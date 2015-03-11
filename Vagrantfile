# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = 'ubuntu/trusty64'

  config.vm.provision 'shell', inline: <<-SHELL
    apt-get update
    apt-get install -y ruby1.9.1-dev \
                       git \
                       mongodb-server=1:2.4.9-1ubuntu2
    gem install bundler

    # stop mongodb and disable it starting at boot
    service mongodb stop
    echo 'manual' >> /etc/init/mongodb.override
  SHELL

  config.vm.provision 'shell', privileged: false, inline: <<-SHELL
    cd /vagrant
    bundle install
  SHELL
end
