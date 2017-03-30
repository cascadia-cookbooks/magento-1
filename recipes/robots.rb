#
# Cookbook Name:: magento
# Recipe:: robots
#

# Create 'robots.txt' from template
template 'Creating robots.txt' do
    path    '/var/www/shared/pub/robots.txt'
    source  'robots/robots.txt.erb'
    owner   node['magento']['users']['cli']['name']
    group   node['magento']['groups']['www-data']['name']
    mode    0644
    action  :create
    backup  false
    only_if {node['robots']}
end
