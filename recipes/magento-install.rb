#
# Cookbook Name:: magento
# Recipe:: magento-install
#

docroot                 = node['magento']['docroot']
magento_path            = node['magento']['installation_path']
magento_bin             = "#{magento_path}/bin/magento"
magento_composer_home   = "#{magento_path}/var/composer_home"

cli_user                = node['magento']['cli_user']['name']
cli_group               = node['magento']['cli_user']['group']

www_user                = node['magento']['www_user']['name']
www_group               = node['magento']['www_user']['group']

composer_home           = "/home/#{cli_user}/.composer"

verbosity               = node['magento']['installation']['verbosity']

# Composer installation flags
composer_base_flags     = '--no-interaction --no-ansi'
composer_pref_flags     = '--no-suggest --prefer-dist'
composer_include_dev    = node.environment != 'development' ? '--no-dev' : ''
composer_install_flags  = "#{composer_base_flags} #{composer_pref_flags} #{composer_include_dev}"
composer_update_flags   = "#{composer_base_flags} #{composer_pref_flags} --lock #{composer_include_dev}"

# Magento installation flags
magento_install_flags = "--base-url=http://#{node['magento']['domain']} \
--db-host=#{node['magento']['mysql']['connection']['default']['host']} \
--db-name=#{node['magento']['mysql']['connection']['default']['dbname']} \
--db-user=#{node['magento']['mysql']['connection']['default']['username']} \
--db-password=#{node['magento']['mysql']['connection']['default']['password']} \
--admin-firstname=#{node['magento']['installation']['admin_first']} \
--admin-lastname=#{node['magento']['installation']['admin_last']} \
--admin-email=#{node['magento']['installation']['admin_email']} \
--admin-user=#{node['magento']['installation']['admin_user']} \
--admin-password=#{node['magento']['installation']['admin_pass']} \
--language=#{node['magento']['installation']['language']} \
--currency=#{node['magento']['installation']['currency']} \
--timezone=#{node['magento']['installation']['app_timezone']} \
--backend-frontname=#{node['magento']['installation']['backend_frontname']} \
--use-rewrites=1"

# Append Magento installation flags
if node['magento']['installation']['sample_data']
    magento_install_flags = "--use-sample-data #{magento_install_flags}"
end

# Run composer install
execute 'Composer installing' do
    command     "composer install -#{verbosity} #{composer_install_flags}"
    cwd         magento_path
    user        cli_user
    group       www_group
    environment ({
        'COMPOSER_HOME'      => composer_home,
        'COMPOSER_CACHE_DIR' => "#{composer_home}/cache"
    })
    not_if      { ::File.exist?("#{magento_path}/app/etc/env.php") }
    notifies    :run, 'execute[Change directory permissions]', :immediately
    notifies    :run, 'execute[Change file permissions]', :immediately
    notifies    :create, "link[Symlink docroot]", :immediately
    notifies    :run, 'execute[Update magento bin permissions]', :immediately
    notifies    :run, 'execute[Install sample data if desired]', :immediately
    notifies    :run, 'execute[Update composer if sample data]', :immediately
    notifies    :run, 'execute[Magento setup]', :immediately
    notifies    :run, 'execute[Remove sample files]', :delayed
end

execute 'Change directory permissions' do
    command 'find var vendor pub/static pub/media app/etc -type d -exec chmod u+w {} \;'
    cwd     magento_path
    user    cli_user
    group   www_group
    action  :nothing
    only_if { node['magento']['update_permissions'] }
end

execute 'Change file permissions' do
    command 'find var vendor pub/static pub/media app/etc -type f -exec chmod u+w {} \;'
    cwd     magento_path
    user    cli_user
    group   www_group
    action  :nothing
    only_if { node['magento']['update_permissions'] }
end

link "Symlink docroot" do
    target_file "#{docroot}/current"
    to          magento_path
    owner       cli_user
    group       www_group
   action       :nothing
end
#
execute 'Update magento bin permissions' do
    command "chmod 775 #{magento_bin}"
    action  :nothing
    only_if { node['magento']['update_permissions'] }
end
#
execute 'Install sample data if desired' do
    command "#{magento_bin} sampledata:deploy"
    user    cli_user
    action  :nothing
    only_if { node['magento']['installation']['sample_data'] }
end

execute 'Update composer if sample data' do
    command     "composer update #{composer_update_flags}"
    user        cli_user
    cwd         magento_path
    environment ({
        'COMPOSER_HOME'      => composer_home,
        'COMPOSER_CACHE_DIR' => "#{composer_home}/cache"
    })
    action      :nothing
    only_if     { node['magento']['installation']['sample_data'] }
end

execute 'Magento setup' do
    command "#{magento_bin} setup:install #{magento_install_flags} --no-ansi"
    user    cli_user
    group   www_group
    cwd     magento_path
    action  :nothing
end

execute 'Remove sample files' do
    command 'rm -rf *.sample'
    cwd     magento_path
    action  :nothing
    not_if  'find -type f -name *.sample'
end

# Link shared/app/etc/env.php
link "#{magento_path}/app/etc/env.php" do
    to    "#{docroot}/shared/app/etc/env.php"
    owner cli_user
    group www_group
end

execute 'Set Magento deploy mode' do
    command "#{magento_bin} -#{verbosity} deploy:mode:set #{node['magento']['mage_mode']} --skip-compilation"
    cwd     magento_path
    user    cli_user
    group   www_group
end

execute 'Magento di compile' do
    command "#{magento_bin} -#{verbosity} setup:di:compile"
    cwd     magento_path
    user    cli_user
    group   www_group
    only_if { node['magento']['mage_mode'] == 'production' }
end

execute 'Magento static content deploy' do
    command "#{magento_bin} -#{verbosity} setup:static-content:deploy"
    cwd     magento_path
    user    cli_user
    group   www_group
    only_if { node['magento']['mage_mode'] == 'production' }
end

execute 'Magento setup:upgrade' do
    command "#{magento_bin} -#{verbosity} setup:upgrade"
    cwd     magento_path
    user    cli_user
    group   www_group
end

php_pool = node['magento']['application']['php_fpm_pool']
fpm_location = node['php']['sapi']['fpm']['conf']['pools'][php_pool]['listen'].tr('"', '')

# Set Magento 2 vhost
magento_vhost node['magento']['domain'] do
    nginx_listen '0.0.0.0:80'
    docroot      "#{docroot}/current/pub"
    fpm_location "unix:#{fpm_location}"
    action       :create
end
