#
# Cookbook Name:: magento
# Recipe:: app-etc
#

cli_user           = node['magento']['cli_user']['name']
cli_group          = node['magento']['cli_user']['group']

www_user           = node['magento']['www_user']['name']
www_group          = node['magento']['www_user']['group']

docroot            = node['magento']['docroot']
additional_domains = node['magento']['additional_domains']

# Generate env.php
template 'Install env.php' do
    path    "#{docroot}/shared/app/etc/env.php"
    source  'magento/env.php.erb'
    owner   cli_user
    group   www_group
    mode    0644
    action  :create
    backup  false
end

additional_domains.each do |domain|
    template 'Install env.php' do
        path    "/var/www/#{domain}/shared/app/etc/env.php"
        source  'magento/env.php.erb'
        owner   cli_user
        group   www_group
        mode    0644
        action  :create
        backup  false
    end
end
