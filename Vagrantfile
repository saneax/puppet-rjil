# -*- mode: ruby -*-
# vi: set ft=ruby :
require 'yaml'

Vagrant.configure("2") do |config|

  default_flavor = 'small'
  default_image = 'trusty'

  # allow users to set their own environment
  # which effect the hiera hierarchy and the
  # cloud file that is used
  environment = ENV['env'] || 'vagrant-vbox'
  layout = ENV['layout'] || 'full'
  map = ENV['map'] || environment

  config.vm.provider :virtualbox do |vb, override|
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
  end

  config.vm.provider "lxc" do |v, override|
    override.vm.box = "fgrehm/trusty64-lxc"
  end

  last_octet = 41
  env_data = YAML.load_file("environment/#{layout}.yaml")

  map_data = YAML.load_file("environment/#{map}.map.yaml")


  machines = {}
  env_data['resources'].each do |name, info|
    (1..info['number']).to_a.each do |idx|
      machines["#{name}#{idx}"] = info
    end
  end

  machines.each do |node_name, info|

    config.vm.define(node_name) do |config|
      config.vm.host_name = "#{node_name}.domain.name"
      config.vm.provider :virtualbox do |vb, override|
        image = info['image'] || default_image
        override.vm.box = map_data['image']['virtualbox'][image]

        flavor = info['flavor'] || default_flavor
        vb.memory = map_data['flavor'][flavor]['ram']
        vb.cpus = map_data['flavor'][flavor]['cpu']
      end

      config.vm.synced_folder("hiera/", '/etc/puppet/hiera.overrides/')
      config.vm.synced_folder("modules/", '/etc/puppet/modules.overrides/')
      config.vm.synced_folder("manifests/", '/etc/puppet/modules.overrides/rjil/manifests/')
      config.vm.synced_folder("files/", '/etc/puppet/modules.overrides/rjil/files/')
      config.vm.synced_folder("templates/", '/etc/puppet/modules.overrides/rjil/templates/')
      config.vm.synced_folder("lib/", '/etc/puppet/modules.overrides/rjil/lib/')
      config.vm.synced_folder(".", "/etc/puppet/manifests.overrides")

      config.vm.provision 'shell', :inline =>
      'cp /etc/puppet/hiera.overrides/hiera.yaml /etc/puppet'

      #variable build_puppet is introduced with value no, so as to not to do git clone and librarian puppet on
      config.vm.provision 'shell', :inline =>
        "export consul_discovery_token=#{ENV['consul_discovery_token']};export layout=full;export map=#{map};export cloud_provider=vagrant-box;export puppet_modules_source_repo='https://github.com/JioCloud/puppet-rjil';export build_puppet=false;/etc/puppet/manifests.overrides/build_scripts/make_userdata.sh;bash -x ./userdata.txt"

      net_prefix = ENV['NET_PREFIX'] || "192.168.100.0"
      config.vm.network "private_network", :type => :dhcp, :ip => net_prefix, :netmask => "255.255.255.0"
    end
  end
end
