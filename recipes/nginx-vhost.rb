#
# Cookbook Name:: magento
# Recipe:: nginx-vhost
#

docroot      = node['magento']['docroot']
php_pool     = node['magento']['application']['php_fpm_pool']
fpm_location = node['php']['sapi']['fpm']['conf']['pools'][php_pool]['listen'].tr('"', '')

# Set Magento 2 vhost
magento_vhost node['magento']['domain'] do
    nginx_listen '0.0.0.0:80'
    docroot      "#{docroot}/current/pub"
    fpm_location "unix:#{fpm_location}"
    action       :create
end
