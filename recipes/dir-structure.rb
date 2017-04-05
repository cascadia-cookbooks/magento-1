#
# Cookbook Name:: magento
# Recipe:: dir-structure
#

# Creates directory structure for the /var/www/ docroot

docroot            = node['magento']['docroot']
additional_domains = node['magento']['additional_domains']

dirs = %w(
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
directory "#{docroot}" do
    owner     node['magento']['users']['www']['name']
    group     node['magento']['users']['www']['group']
    mode      0755
    recursive true
    action    :create
end

dirs.each do |dir|
    directory "#{docroot}/#{dir}" do
        owner     node['magento']['users']['www']['name']
        group     node['magento']['users']['www']['group']
        mode      0755
        recursive true
        action    :create
    end
end

# Create structure for any additional domains
additional_domains.each do |domain|
    directory "/var/www/#{domain}" do
        owner     node['magento']['users']['www']['name']
        group     node['magento']['users']['www']['group']
        mode      0755
        recursive true
        action    :create
    end

    dirs.each do |dir|
        directory "/var/www/#{domain}/#{dir}" do
            owner     node['magento']['users']['www']['name']
            group     node['magento']['users']['www']['group']
            mode      0755
            recursive true
            action    :create
        end
    end
end
