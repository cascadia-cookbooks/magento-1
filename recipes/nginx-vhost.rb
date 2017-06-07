#
# Cookbook Name:: magento
# Recipe:: nginx-vhost
#

php_pool     = node['magento']['application']['php_fpm_pool']
fpm_location = node['php']['sapi']['fpm']['conf']['pools'][php_pool]['listen'].tr('"', '')

template 'magento config for nginx' do
    path   '/etc/nginx/magento'
    source 'nginx/magento.erb'
    owner  'root'
    group  'root'
    mode   0755
    action :create
    variables(
        :fpm_location => "unix:#{fpm_location}"
    )
    notifies :reload, 'service[nginx]', :immediately
end
