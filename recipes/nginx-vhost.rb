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
    mode   0644
    action :create
    variables(
        fpm_location: "unix:#{fpm_location}",
        fastcgi_read_timeout: node['magento']['nginx']['fastcgi_read_timeout'],
        fastcgi_connect_timeout: node['magento']['nginx']['fastcgi_connect_timeout'],
    )
    notifies :restart, 'service[nginx]', :delayed
end

# magento RUN variables
template 'magento variables for nginx' do
    path   "#{node['nginx']['vhost_dir']}/magento.conf"
    source 'nginx/magento.conf.erb'
    owner  'root'
    group  'root'
    mode   0644
    action :create
    notifies :restart, 'service[nginx]', :delayed
end
