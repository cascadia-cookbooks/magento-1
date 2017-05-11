#
# Cookbook Name:: magento
# Recipe:: pre-deploy
#

include_recipe 'cop_magento::data-bag'
include_recipe 'cop_magento::users'
include_recipe 'cop_magento::cli-tools'
include_recipe 'cop_magento::dir-structure'
include_recipe 'cop_magento::permissions'
include_recipe 'cop_magento::robots'
include_recipe 'cop_magento::composer-prep'
include_recipe 'cop_magento::nginx-vhost'
