# Magento
default['magento']['version']          = '2.1.4'
default['magento']['edition']          = 'Community'
default['magento']['composer_project'] = 'magento/product-community-edition'

default['magento']['domain']             = 'www.example.com'
default['magento']['additional_domains'] = {}

default['magento']['users']['cli']['name']  = 'mage-cli'
default['magento']['users']['cli']['group'] = 'cli'
default['magento']['users']['www']['name']  = 'www-data'
default['magento']['users']['www']['group'] = 'www-data'

default['magento']['groups']['cli']['name']         = 'cli'
default['magento']['groups']['cli']['members']      = ['mage-cli']
default['magento']['groups']['www-data']['name']    = 'www-data'
default['magento']['groups']['www-data']['members'] = ['www-data', 'mage-cli']

default['magento']['directories'] = {}
default['magento']['files']       = {}

default['magento']['update_permissions'] = true

default['magento']['tools']['magerun']['path']    = '/usr/local/bin/n98-magerun2'
default['magento']['tools']['magerun']['source']  = 'n98-magerun2.phar'
default['magento']['tools']['magerun']['owner']   = 'mage-cli'
default['magento']['tools']['magerun']['group']   = 'cli'
default['magento']['tools']['magerun']['mode']    = '0755'

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
default['magento']['mysql']['connection']['default']['host']           = 'localhost'
default['magento']['mysql']['connection']['default']['model']          = 'mysql4'
default['magento']['mysql']['connection']['default']['engine']         = 'innodb'
default['magento']['mysql']['connection']['default']['initStatements'] = 'SET NAMES utf8'
default['magento']['mysql']['connection']['default']['active']         = '1'

default['magento']['resource']['default_setup']['connection'] = 'default'

default['magento']['x_frame_options'] = 'SAMEORIGIN'

default['magento']['mage_mode'] = 'production'

default['magento']['cache_types']['config']                  = 1
default['magento']['cache_types']['layout']                  = 1
default['magento']['cache_types']['block_html']              = 1
default['magento']['cache_types']['collections']             = 1
default['magento']['cache_types']['reflection']              = 1
default['magento']['cache_types']['db_ddl']                  = 1
default['magento']['cache_types']['eav']                     = 1
default['magento']['cache_types']['customer_notification']   = 1
default['magento']['cache_types']['full_page']               = 1
default['magento']['cache_types']['config_integration']      = 1
default['magento']['cache_types']['config_intergration_api'] = 1
default['magento']['cache_types']['translate']               = 1
default['magento']['cache_types']['config_webservice']       = 1


# Composer
default['composer']['merge']['version']     = 'v1.3.1'
default['composer']['merge']['recurse']     = false
default['composer']['merge']['replace']     = true
default['composer']['merge']['merge_dev']   = true
default['composer']['merge']['merge_extra'] = true

default['composer']['binary']['path']       = '/usr/local/bin/composer'

default['composer']['repositories']['repo.magento.com']['username'] = ''
default['composer']['repositories']['repo.magento.com']['password'] = ''
default['composer']['repositories']['copious_repos']['token']       = ''
