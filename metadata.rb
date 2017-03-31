name                'cop_magento'
description         'Prepares the environment for Magento 2'
long_description    IO.read(File.join(File.dirname(__FILE__), 'README.md'))
license             'MIT'
maintainer          'Copious, Inc.'
maintainer_email    'engineering@copiousinc.com'
version             '0.0.0'
source_url          'https://github.com/copious-cookbooks/magento'
issues_url          'https://github.com/copious-cookbooks/magento/issues'

supports 'ubuntu', '>=14.04'
supports 'debian', '>= 7'
supports 'rhel', '>= 6'
supports 'centos', '>= 6'

depends 'cop_base'
depends 'cop_iptables'
depends 'cop_cron'
depends 'cop_mysql'
depends 'cop_varnish'
depends 'cop_redis'
depends 'cop_nginx'
depends 'cop_php'
depends 'cop_ntp'
