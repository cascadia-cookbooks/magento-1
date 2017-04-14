# Magento 2 Cookbook

## Platforms

* Ubuntu >= 14.04
* RHEL/CentOS >= 6

## Attributes

* `node['magento']['version']` (string) defaults to 2.1.4
* `node['magento']['edition']` (string) 'Community' or 'Enterprise', defaults to 'Community'
* `node['magento']['composer_project']` (string) defaults to 'magento/product-community-edition', should match `node['magento']['edition']`

* `node['magento']['domain']` (string) defaults to 'example.com'
* `node['magento']['additional_domains']` (string) any additional domain names

* `node['magento']['docroot']` (string) defaults to `/var/www/<domain>`

* `node['magento']['update_permissions']` (boolean) update Magento file and directory permissions, defaults to `true`

* `node['magento']['installation']['verbosity']` (string) verbosity of Composer and Magento install, defaults to `vvv` 

* `node['magento']['installation']['*']` Parameters for Magento installation. A complete list with defaults follows:

```
['admin_first']       = 'Admin'
['admin_last']        = 'User'
['admin_email']       = 'admin@example.com'
['admin_user']        = 'admin'
['admin_pass']        = 'mage123'
['language']          = 'en_US'
['currency']          = 'USD'
['app_timezone']      = 'America/Los_Angeles'
['backend_frontname'] = 'admin'
['crypt_key']         = ''
['date']              = Time.now.strftime("%a, %d %B %Y %H:%M:%S +0000")
['sample_data']       = false
```

## Usage

Here's an example `web` role that will install Magento

```
name 'web'
description 'install Magento'

override_attributes(
    'magento': {
        'version': '2.1.2',
        'domain': 'example.net',
        'docroot': '/var/web/html'
        ...
    }
)

run_list(
    'recipe[cop_magento::default]'
)
```

## Testing
* http://kitchen.ci
* http://serverspec.org

Testing is handled with ServerSpec, via Test Kitchen, which uses Vagrant to spin up VMs.

ServerSpec and Test Kitchen are bundled in the ChefDK package.

### Dependencies
* https://downloads.chef.io/chefdk

### Running
Get a listing of your instances with:

```bash
$ kitchen list
```

Run Chef on an instance, in this case default-centos-7, with:

```bash
$ kitchen converge default-centos-7
```

Destroy all instances with:

```bash
$ kitchen destroy
```

Run through and test all the instances in serial by running:

```bash
$ kitchen test
```
