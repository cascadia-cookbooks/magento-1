#
# Cookbook Name:: magento
# Recipe:: full-install
#

include_recipe 'cop_magento::data-bag'
include_recipe 'cop_magento::cli-tools'
include_recipe 'cop_magento::dir-structure'
if node.chef_environment == "development"
    include_recipe 'cop_magento::dir-structure-vagrant'
end
include_recipe 'cop_magento::permissions'
include_recipe 'cop_magento::robots'
include_recipe 'cop_magento::composer-prep'
include_recipe 'cop_magento::magento-install'
