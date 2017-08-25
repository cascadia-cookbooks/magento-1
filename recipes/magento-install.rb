#
# Cookbook Name:: magento
# Recipe:: magento-install
#

docroot                 = node['magento']['docroot']
magento_path            = node['magento']['installation_path']
release_path            = node['magento']['release']
magento_bin             = "#{magento_path}/bin/magento"
magento_composer_home   = "#{magento_path}/var/composer_home"

cli_user                = node['magento']['cli_user']['name']
cli_group               = node['magento']['cli_user']['group']

www_user                = node['magento']['www_user']['name']
www_group               = node['magento']['www_user']['group']

composer_home           = "/home/#{cli_user}/.composer"
composer_binary_path    = node['composer']['binary']['path']

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

# Check for app/etc/env.php, exit recipe if present
# NOTE: This has historically acted as our check to see whether the Magento
# installation process has occured or not; this deserves to be reevaluated
if ::File.exist?("#{magento_path}/app/etc/env.php")
    return
end

# Run composer install
execute 'Composer installing' do
    command     "#{composer_binary_path} install -#{verbosity} #{composer_install_flags}"
    cwd         magento_path
    user        cli_user
    group       www_group
    environment ({
        'COMPOSER_HOME'      => composer_home,
        'COMPOSER_CACHE_DIR' => "#{composer_home}/cache"
    })
end

execute 'Change directory permissions' do
    command 'find var vendor pub/static pub/media app/etc -type d -exec chmod u+w {} \;'
    cwd     magento_path
    user    cli_user
    group   www_group
    only_if { node['magento']['update_permissions'] }
end

execute 'Change file permissions' do
    command 'find var vendor pub/static pub/media app/etc -type f -exec chmod u+w {} \;'
    cwd     magento_path
    user    cli_user
    group   www_group
    only_if { node['magento']['update_permissions'] }
end

link "Symlink docroot" do
    target_file "#{docroot}/current"
    to          release_path
    owner       cli_user
    group       www_group
end
#
execute 'Update magento bin permissions' do
    command "chmod 775 #{magento_bin}"
    only_if { node['magento']['update_permissions'] }
end
#
execute 'Install sample data if desired' do
    command "#{magento_bin} sampledata:deploy"
    user    cli_user
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
    only_if     { node['magento']['installation']['sample_data'] }
end

execute 'Magento setup:install' do
    command "#{magento_bin} setup:install #{magento_install_flags} --no-ansi"
    user    cli_user
    group   www_group
    cwd     magento_path
end

execute 'Remove sample files' do
    command 'rm -rf *.sample'
    cwd     magento_path
    not_if  'find -type f -name *.sample'
end

# Link shared/app/etc/env.php
link "#{magento_path}/app/etc/env.php" do
    to    "#{docroot}/shared/app/etc/env.php"
    owner cli_user
    group www_group
end

# Link `robots.txt`
link "#{magento_path}/pub/robots.txt" do
    to    "#{docroot}/shared/pub/robots.txt"
    owner cli_user
    group www_group
end

# Stop 'cron' service
service node['cron']['service'] do
    action :stop
end

# Kill any bin/magento cron jobs
execute 'Kill bin/magento cron jobs' do
    command "pkill -f 'bin/magento cron'"
    returns [0,1] # `pkill` returns `1` if pattern is unmatched
    user    'root'
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

# Start 'cron' service
service node['cron']['service'] do
    action :start
end
