# -*- mode: ruby -*-
# vi: set ft=ruby :


Vagrant::Config.run do |config|

    config.vm.box = "precise64"

    config.vm.box_url = "http://files.vagrantup.com/precise64.box"

    config.vm.network :hostonly, "33.33.33.100" # Host-Only networking required for nfs shares

    config.vm.share_folder("symfony", "/vagrant", "./", :nfs => (RUBY_PLATFORM =~ /linux/ or RUBY_PLATFORM =~ /darwin/))

    config.vm.provision :puppet do |puppet|
        puppet.manifests_path = "puppet/manifests"
        puppet.module_path = "puppet/modules"
        puppet.options = ['--verbose']
	end

end