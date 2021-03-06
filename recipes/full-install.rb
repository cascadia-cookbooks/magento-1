#
# Cookbook Name:: magento
# Recipe:: full-install
#

include_recipe 'cop_magento::data-bag'
include_recipe 'cop_magento::n98-install'
include_recipe 'cop_magento::dir-structure'
include_recipe 'cop_magento::robots'
include_recipe 'cop_magento::composer-prep'
include_recipe 'cop_magento::app-etc'
include_recipe 'cop_magento::nginx-vhost'
include_recipe 'cop_magento::magento-install'
