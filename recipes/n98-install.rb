#
# Cookbook Name:: magento
# Recipe:: n98-install
#

n98 = node['magento']['n98']

if n98['enabled'] == true
    remote_file 'N98-Magerun CLI Tool' do
        source   "https://files.magerun.net/n98-magerun2-#{n98['version']}.phar"
        checksum n98['checksum']
        path     n98['path']
        owner    n98['owner']
        group    n98['group']
        mode     n98['mode']
        action   :create
    end
end
