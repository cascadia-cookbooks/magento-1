#
# Cookbook Name:: magento
# Recipe:: default
#

include_recipe 'cop_magento::users'
include_recipe 'cop_magento::permissions'
include_recipe 'cop_magento::cli-tools'
