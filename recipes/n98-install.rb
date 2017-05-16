#
# Cookbook Name:: magento
# Recipe:: n98-install
#

n98_version  = node['magento']['n98']['version']
n98_checksum = node['magento']['n98']['checksum']
n98_owner    = node['magento']['cli_user']['name']
n98_group    = node['magento']['cli_user']['group'] 

remote_file 'N98-Magerun CLI Tool' do
    source   "https://files.magerun.net/n98-magerun2-#{n98_version}.phar"
    path     '/usr/local/bin/n98-magerun2'
    checksum n98_checksum
    owner    n98_owner
    group    n98_group
    mode     '0755'
    action   :create
end
