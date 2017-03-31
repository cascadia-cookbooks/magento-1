#
# Cookbook Name:: magento
# Recipe:: composer-prep
#

cli_user                = node['magento']['users']['cli']['name']
cli_group               = node['magento']['groups']['cli']['name']

composer_home           = node['magento']['directories']['composer_home']['path']
magento_composer_home   = node['magento']['directories']['magento_composer_home']['path']
magento_path            = node['magento']['directories']['magento']['path']

template 'Installing composer auth.json' do
    path    "#{composer_home}/auth.json"
    source  'composer/auth.json.erb'
    owner   cli_user
    group   cli_group
    mode    0644
    action  :create
    backup  false
end

template 'Installing magento composer auth.json' do
    path    "#{magento_composer_home}/auth.json"
    source  'composer/auth.json.erb'
    owner   cli_user
    group   cli_group
    mode    0644
    action  :create
    backup  false
end

template 'Creating composer.json' do
    path    "#{magento_path}/composer.json"
    source  'composer/composer.json.erb'
    owner   cli_user
    group   cli_group
    mode    0644
    action  :create
    backup  false
end
