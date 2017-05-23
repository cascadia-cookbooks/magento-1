#
# Cookbook Name:: magento
# Recipe:: dir-structure
#

# Creates directory structure for the docroot

docroot            = node['magento']['docroot']
additional_domains = node['magento']['additional_domains']

cli_user           = node['magento']['cli_user']['name']
cli_group          = node['magento']['cli_user']['group']

www_user           = node['magento']['www_user']['name']
www_group          = node['magento']['www_user']['group']

dirs = %w(
    releases
    releases/primary
    releases/primary/magento
    releases/primary/magento/app
    releases/primary/magento/app/etc
    releases/primary/magento/var
    releases/primary/magento/var/session
    releases/primary/magento/vendor
    shared
    shared/app
    shared/app/etc
    shared/composer
    shared/pub
    shared/pub/static
    shared/pub/media
    shared/var
)

# Create structure for default domain
directory docroot do
    owner     cli_user
    group     www_group
    mode      0775
    recursive true
    action    :create
end

dirs.each do |dir|
    directory "#{docroot}/#{dir}" do
        owner     cli_user
        group     www_group
        mode      0775
        recursive true
        action    :create
    end
end

# Create structure for any additional domains
additional_domains.each do |domain|
    directory "/var/www/#{domain}" do
        owner     cli_user
        group     www_group
        mode      0775
        recursive true
        action    :create
    end

    dirs.each do |dir|
        directory "/var/www/#{domain}/#{dir}" do
            owner     cli_user
            group     www_group
            mode      0775
            recursive true
            action    :create
        end
    end
end
