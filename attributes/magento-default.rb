# Magento
default['magento']['version']          = '2.1.7'
default['magento']['edition']          = 'Community'
default['magento']['composer_project'] = 'magento/product-community-edition'

default['magento']['domain']             = 'example.com'
default['magento']['additional_domains'] = {}

# Docroot
default['magento']['docroot']           = "/var/www/#{node['magento']['domain']}"
default['magento']['installation_path'] = "#{node['magento']['docroot']}/releases/primary/magento"
default['magento']['release']           = "#{node['magento']['docroot']}/releases/primary"

# Users and groups
default['magento']['cli_user']['name']  = 'mage-cli'
default['magento']['cli_user']['group'] = 'cli'
default['magento']['www_user']['name']  = 'www-data'
default['magento']['www_user']['group'] = 'www-data'

default['magento']['update_permissions'] = true

default['magento']['directory']['permissions'] = 0775

# Installation Parameters
default['magento']['installation']['admin_first']       = 'Admin'
default['magento']['installation']['admin_last']        = 'User'
default['magento']['installation']['admin_email']       = 'admin@example.com'
default['magento']['installation']['admin_user']        = 'admin'
default['magento']['installation']['admin_pass']        = 'mage123'
default['magento']['installation']['language']          = 'en_US'
default['magento']['installation']['currency']          = 'USD'
default['magento']['installation']['app_timezone']      = 'America/Los_Angeles'
default['magento']['installation']['backend_frontname'] = 'admin'
default['magento']['installation']['crypt_key']         = ''
default['magento']['installation']['date']              = Time.now.strftime("%a, %d %B %Y %H:%M:%S +0000")
default['magento']['installation']['sample_data']       = false

default['magento']['installation']['verbosity']         = 'vvv'

# Session
default['magento']['session']['save']                           = 'redis'
default['magento']['session']['redis']['host']                  = 'localhost'
default['magento']['session']['redis']['port']                  = '6379'
default['magento']['session']['redis']['password']              = ''
default['magento']['session']['redis']['timeout']               = '2.5'
default['magento']['session']['redis']['persistent_identifier'] = ''
default['magento']['session']['redis']['database']              = '0'
default['magento']['session']['redis']['compression_threshold'] = '2048'
default['magento']['session']['redis']['compression_library']   = 'gzip'
default['magento']['session']['redis']['log_level']             = '1'
default['magento']['session']['redis']['max_concurrency']       = '6'
default['magento']['session']['redis']['break_after_frontend']  = '5'
default['magento']['session']['redis']['break_after_adminhtml'] = '30'
default['magento']['session']['redis']['first_lifetime']        = '600'
default['magento']['session']['redis']['bot_first_lifetime']    = '60'
default['magento']['session']['redis']['bot_lifetime']          = '7200'
default['magento']['session']['redis']['disable_locking']       = '0'
default['magento']['session']['redis']['min_lifetime']          = '60'
default['magento']['session']['redis']['max_lifetime']          = '2592000'

# Cache
default['magento']['cache']['save']                                          = 'redis'
default['magento']['cache']['redis']['default']['backend']                   = 'Cm_Cache_Backend_Redis'
default['magento']['cache']['redis']['default']['server']                    = 'localhost'
default['magento']['cache']['redis']['default']['port']                      = '6379'
default['magento']['cache']['redis']['default']['persistent']                = ''
default['magento']['cache']['redis']['default']['database']                  = '1'
default['magento']['cache']['redis']['default']['password']                  = ''
default['magento']['cache']['redis']['default']['force_standalone']          = '0'
default['magento']['cache']['redis']['default']['connect_retries']           = '1'
default['magento']['cache']['redis']['default']['read_timeout']              = '10'
default['magento']['cache']['redis']['default']['automatic_cleaning_factor'] = '0'
default['magento']['cache']['redis']['default']['compress_data']             = '1'
default['magento']['cache']['redis']['default']['compress_tags']             = '1'
default['magento']['cache']['redis']['default']['compress_threshold']        = '20480'
default['magento']['cache']['redis']['default']['compression_lib']           = 'gzip'
default['magento']['cache']['redis']['default']['use_lua']                   = '0'
default['magento']['cache']['redis']['page_cache']['backend']                = 'Cm_Cache_Backend_Redis'
default['magento']['cache']['redis']['page_cache']['server']                 = 'localhost'
default['magento']['cache']['redis']['page_cache']['port']                   = '6379'
default['magento']['cache']['redis']['page_cache']['persistent']             = ''
default['magento']['cache']['redis']['page_cache']['database']               = '2'
default['magento']['cache']['redis']['page_cache']['password']               = ''
default['magento']['cache']['redis']['page_cache']['force_standalone']       = '0'
default['magento']['cache']['redis']['page_cache']['connect_retries']        = '1'
default['magento']['cache']['redis']['page_cache']['lifetimelimit']          = '57600'
default['magento']['cache']['redis']['page_cache']['compress_data']          = '0'

default['magento']['application']['php_fpm_pool'] = 'www'

default['magento']['mysql']['table_prefix']                            = ''
default['magento']['mysql']['connection']['default']['dbname']         = 'magento'
default['magento']['mysql']['connection']['default']['username']       = 'mage'
default['magento']['mysql']['connection']['default']['host']           = '127.0.0.1'
default['magento']['mysql']['connection']['default']['model']          = 'mysql4'
default['magento']['mysql']['connection']['default']['engine']         = 'innodb'
default['magento']['mysql']['connection']['default']['initStatements'] = 'SET NAMES utf8'
default['magento']['mysql']['connection']['default']['active']         = '1'

default['magento']['resource']['default_setup']['connection'] = 'default'

default['magento']['x_frame_options'] = 'SAMEORIGIN'

default['magento']['mage_mode'] = 'production'

default['magento']['cache_types'] = {
    "config" => 1,
    "layout" => 1,
    "block_html" => 1,
    "collections" => 1,
    "reflection" => 1,
    "db_ddl" => 1,
    "eav" => 1,
    "customer_notification" => 1,
    "full_page" => 1,
    "config_integration" => 1,
    "config_integration_api" => 1,
    "translate" => 1,
    "config_webservice" => 1
}

if node.recipe?('cop_varnish::default')
    default['magento']['varnish']['enabled'] = true
else
    default['magento']['varnish']['enabled'] = false
end

# n98-magerun2 attributes
default['magento']['n98']['enabled']  = true
default['magento']['n98']['version']  = '1.6.0'
default['magento']['n98']['checksum'] = '3f185a4199d0137bc0961ed6eebe37b1c9363496101df56457ddfb591523ac6a'
default['magento']['n98']['path']     = '/usr/local/bin/n98-magerun2'
default['magento']['n98']['owner']    = 'root'
default['magento']['n98']['group']    = 'root'
default['magento']['n98']['mode']     = '0755'
