default['magento']['tools']['composer']['path']   = '/usr/local/bin/composer'
default['magento']['tools']['composer']['source'] = 'composer.phar'
default['magento']['tools']['composer']['owner']  = 'mage-cli'
default['magento']['tools']['composer']['group']  = 'cli'
default['magento']['tools']['composer']['mode']   = '0755'
default['magento']['tools']['magerun']['path']    = '/usr/local/bin/n98-magerun2'
default['magento']['tools']['magerun']['source']  = 'n98-magerun2.phar'
default['magento']['tools']['magerun']['owner']   = 'mage-cli'
default['magento']['tools']['magerun']['group']   = 'cli'
default['magento']['tools']['magerun']['mode']    = '0755'

default['magento']['users']['cli']['name']  = 'mage-cli'
default['magento']['users']['cli']['group'] = 'cli'
default['magento']['users']['www']['name']  = 'www-data'
default['magento']['users']['www']['group'] = 'www-data'

default['magento']['groups']['cli']['name'] = 'cli'
default['magento']['groups']['cli']['members'] = ['mage-cli']
default['magento']['groups']['www-data']['name'] = 'www-data'
default['magento']['groups']['www-data']['members'] = ['www-data', 'mage-cli']
