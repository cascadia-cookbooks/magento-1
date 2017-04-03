$bag_environment = node.chef_environment
secret = Chef::Config[:encrypted_data_bag_secret]

required_data_bags = [
    'composer',
    'magento',
    'mysql'
]

def check_bag_existance(bag_name)
    search(bag_name, "id:#{$bag_environment}").any? ? true : log_error("You don't have a data-bag for environment: #{bag_name} / #{$bag_environment}")
end

def log_error(error_msg)
    Chef::Log.fatal(error_msg)
    fail error_msg
end

def update_mysql_vars(data_bag_item)
    node.normal['mysql']['root_password']                                = data_bag_item['root-password']
    node.normal['mysql']['users']['mage']['password']                    = data_bag_item['mage-password']
    node.normal['magento']['mysql']['connection']['default']['password'] = data_bag_item['mage-password']
end

def update_composer_vars(data_bag_item)
    node.normal['composer']['repositories']['repo.magento.com']['username'] = data_bag_item['magento-repo-user']
    node.normal['composer']['repositories']['repo.magento.com']['password'] = data_bag_item['magento-repo-password']
    node.normal['composer']['repositories']['copious_repos']['token']       = data_bag_item['copious-repos-token']
end

def update_magento_vars(data_bag_item)
    node.normal['magento']['installation']['crypt_key' ] = data_bag_item['crypt-key']
    node.normal['magento']['installation']['admin_pass'] = data_bag_item['default-admin-password']
end

required_data_bags.each do |bag_name|
    if check_bag_existance(bag_name)
        data_bag_item = data_bag_item(bag_name, $bag_environment, IO.read(secret))

        case bag_name
        when "mysql"
            update_mysql_vars(data_bag_item)
        when "composer"
            update_composer_vars(data_bag_item)
        when "magento"
            update_magento_vars(data_bag_item)
        end
    end
end
