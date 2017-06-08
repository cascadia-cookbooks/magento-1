#
# Cookbook Name:: magento
# Recipe:: nginx-vhost
#

php_pool     = node['magento']['application']['php_fpm_pool']
fpm_location = node['php']['sapi']['fpm']['conf']['pools'][php_pool]['listen'].tr('"', '')

# magento application config
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

# magento RUN variables
template 'magento variables for nginx' do
    path   "#{node['nginx']['vhost_dir']}/magento.conf"
    source 'nginx/magento.conf.erb'
    owner  'root'
    group  'root'
    mode   0755
    action :create
    notifies :reload, 'service[nginx]', :immediately
end
