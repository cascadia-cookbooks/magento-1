#
# Cookbook Name:: magento
# Recipe:: users
#

# Create base Magento users
node['magento']['users'].each do |user_name, user_attr|
    user user_attr['name'] do
        action   :create
        home     "/home/#{user_attr['name']}"
        shell    '/bin/bash'
        not_if   "getent passwd #{user_attr['name']}"
        notifies :reload, 'ohai[reload_passwd]', :immediately
    end
end

# Update groups and group members
node['magento']['groups'].each do |group_name, group_attr|
    group group_attr['name'] do
        action   :create
        members  group_attr['members']
        notifies :reload, 'ohai[reload_passwd]', :immediately
    end
end

# Update user home directory permissions
node['magento']['users'].each do |user_name, user_attr|
    directory "/home/#{user_attr['name']}" do
        owner   user_attr['name']
        group   user_attr['group']
        mode    '0700'
    end
end

# Reload ohai 'etc' plugin
ohai 'reload_passwd' do
    action :nothing
    plugin 'etc'
end
