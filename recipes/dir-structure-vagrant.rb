#
# Cookbook Name:: magento
# Recipe:: dir-structure-vagrant
#

# Create directory structure for Vagrant dev environment

dirs = %w(
    /vagrant
    /vagrant/magento
    /vagrant/magento/app
    /vagrant/magento/app/etc
    /vagrant/magento/var
    /vagrant/magento/var/session
    /vagrant/magento/vendor
)

dirs.each do |dir|
    directory dir do
        owner     'vagrant'
        group     'vagrant'
        mode      0775
        recursive true
        action    :create
    end
end
