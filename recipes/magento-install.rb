#
# Cookbook Name'' magento
# Recipe'' magento-install
#

magento_docroot         = node['magento']['docroot']
magento_path            = node['magento']['directories']['magento']['path']
magento_bin             = "#{magento_path}/bin/magento"
magento_composer_home   = node['magento']['directories']['magento_composer_home']['path']

cli_user                = node['magento']['users']['cli']['name']
cli_group               = node['magento']['groups']['cli']['name']
www_user                = node['magento']['users']['www']['name']
www_group               = node['magento']['groups']['www-data']['name']

composer_home           = node['magento']['directories']['composer_home']['path']

composer_base_flags     = '--no-interaction --no-ansi'
composer_pref_flags     = '--no-suggest --prefer-dist'
composer_include_dev    = node.environment != 'development' ? '--no-dev' : ''
composer_install_flags  = "#{composer_base_flags} #{composer_pref_flags} #{composer_include_dev}"
composer_update_flags   = "#{composer_base_flags} #{composer_pref_flags} --lock #{composer_include_dev}"

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

if node['magento']['installation']['sample_data']
    magento_install_flags = "--use-sample-data #{magento_install_flags}"
end


# Run composer install
execute 'Composer installing' do
    command     "composer install #{composer_install_flags}"
    cwd         magento_path
    user        cli_user
    group       cli_group
    environment ({
        'COMPOSER_HOME'      => composer_home,
        'COMPOSER_CACHE_DIR' => "#{composer_home}/cache"
    })
    not_if      { ::File.exist?("#{magento_path}/app/etc/env.php") }
    notifies    :run, 'execute[Change directory permissions]', :immediately
    notifies    :run, 'execute[Change file permissions]', :immediately
    notifies    :create, "link[#{magento_docroot}]", :immediately
    notifies    :run, 'execute[Update magento bin permissions]', :immediately
    notifies    :run, 'execute[Install sample data if desired]', :immediately
    notifies    :run, 'execute[Update composer if sample data]', :immediately
    notifies    :run, 'execute[Magento setup]', :immediately
    notifies    :run, 'execute[Remove sample files]', :delayed
end

link magento_docroot do
    to "#{magento_path}/pub"
    action  :nothing
end

execute 'Update magento bin permissions' do
    command "chmod 775 #{magento_bin}"
    action  :nothing
    only_if { node['magento']['update_permissions'] }
end

execute 'Install sample data if desired' do
    command "#{magento_bin} sampledata:deploy"
    user    cli_user
    action  :nothing
    only_if { node['magento']['installation']['sample_data'] }
end

execute 'Update composer if sample data' do
    command "composer update #{composer_update_flags}"
    user    cli_user
    cwd     magento_path
    environment ({
        'COMPOSER_HOME'      => composer_home,
        'COMPOSER_CACHE_DIR' => "#{composer_home}/cache"
    })
    action  :nothing
    only_if { node['magento']['installation']['sample_data'] }
end

execute 'Magento setup' do
    command "#{magento_bin} setup:install #{magento_install_flags} --no-ansi"
    user    cli_user
    cwd     magento_path
    action  :nothing
end

template 'Install env.php' do
    path    "#{magento_path}/app/etc/env.php"
    owner   www_user
    group   www_group
    mode    '0644'
    source  'magento/env.php.erb'
    backup  false
    only_if "test -d #{magento_path}/app/etc"
end

execute 'Set Magento deploy mode' do
    command "#{magento_bin} deploy:mode:set #{node['magento']['mage_mode']}"
    cwd     magento_path
    user    cli_user
end

execute 'Magento setup:upgrade' do
    command  "#{magento_bin} setup:upgrade"
    cwd      magento_path
    user    cli_user
end

execute 'Remove sample files' do
    command 'rm -rf *.sample'
    cwd     magento_path
    action  :nothing
    not_if  'find -type f -name *.sample'
end

execute 'Change directory permissions' do
    command 'find var vendor pub/static pub/media app/etc -type d -exec chmod u+w {} \;'
    cwd     magento_path
    user    www_user
    group   www_group
    action  :nothing
    only_if { node['magento']['update_permissions'] }
end

execute 'Change file permissions' do
    command 'find var vendor pub/static pub/media app/etc -type f -exec chmod u+w {} \;'
    cwd     magento_path
    user    www_user
    group   www_group
    action  :nothing
    only_if { node['magento']['update_permissions'] }
end

php_pool = node['magento']['application']['php_fpm_pool']
fpm_location = node['php']['sapi']['fpm']['conf']['pools'][php_pool]['listen'].tr('"', '')

# Set Magento 2 vhost
magento_vhost node['magento']['domain'] do
    nginx_listen  '127.0.0.1:8080'
    docroot       magento_docroot
    fpm_location  "unix:#{fpm_location}"
    action        :create
end
