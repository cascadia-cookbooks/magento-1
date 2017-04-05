#
# Cookbook Name:: magento
# Recipe:: composer-prep
#

cli_user    = node['magento']['users']['cli']['name']
cli_group   = node['magento']['users']['cli']['group']

www_user    = node['magento']['users']['www']['name']
www_group   = node['magento']['users']['www']['group']

docroot     = "/var/www/#{node['magento']['domain']}"

# Create directory for cli_user Composer auth.json
directory "/home/#{cli_user}/.composer" do
    owner   cli_user
    group   cli_group
    mode    0755
    action  :create
end

# Generate Composer auth.json for CLI user
template 'Installing CLI user Composer auth.json' do
    path    "/home/#{cli_user}/.composer/auth.json"
    source  'composer/auth.json.erb'
    owner   cli_user
    group   cli_group
    mode    0644
    action  :create
    backup  false
end

# Generate Composer auth.json for Magento in shared directory
template 'Installing Magento Composer auth.json' do
    path    "#{docroot}/shared/composer/auth.json"
    source  'composer/auth.json.erb'
    owner   www_user
    group   www_group
    mode    0644
    action  :create
    backup  false
end

# Generate Composer composer.json in shared directory
template 'Creating composer.json' do
    path    "#{docroot}/shared/composer/composer.json"
    source  'composer/composer.json.erb'
    owner   www_user
    group   www_group
    mode    0644
    action  :create
    backup  false
end
