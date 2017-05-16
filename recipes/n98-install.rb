#
# Cookbook Name:: magento
# Recipe:: n98-install
#

n98_version  = node['magento']['n98']['version']
n98_checksum = node['magento']['n98']['checksum']
n98_path     = node['magento']['n98']['path']
n98_owner    = node['magento']['n98']['owner']
n98_group    = node['magento']['n98']['group'] 
n98_mode     = node['magento']['n98']['mode'] 

remote_file 'N98-Magerun CLI Tool' do
    source   "https://files.magerun.net/n98-magerun2-#{n98_version}.phar"
    checksum n98_checksum
    path     n98_path
    owner    n98_owner
    group    n98_group
    mode     n98_mode
    action   :create
end
