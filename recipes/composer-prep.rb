#
# Cookbook Name:: magento
# Recipe:: composer-prep
#

cli_user     = node['magento']['cli_user']['name']
cli_group    = node['magento']['cli_user']['group']

www_user     = node['magento']['www_user']['name']
www_group    = node['magento']['www_user']['group']

docroot      = node['magento']['docroot']
magento_path = node['magento']['installation_path']

additional_domains = node['magento']['additional_domains']

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
template 'Creating shared composer.json' do
    path    "#{docroot}/shared/composer/composer.json"
    source  'composer/composer.json.erb'
    owner   www_user
    group   www_group
    mode    0644
    action  :create
    backup  false
end

# Generate Composer composer.json in installation directory
# Only takes effect if 'full-install' recipe is used
if node.recipe?('cop_magento::full-install')
    template 'Creating installation composer.json' do
        path    "#{magento_path}/composer.json"
        source  'composer/composer.json.erb'
        owner   cli_user
        group   www_group
        mode    0644
        action  :create
        backup  false
    end
end
