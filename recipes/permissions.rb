#
# Cookbook Name:: magento
# Recipe:: permissions
#

# Directory permissions
node['magento']['directories'].each do |directory_node, directory_attr|
    directory directory_attr['path'] do
        owner       directory_attr['owner']
        group       directory_attr['group']
        mode        directory_attr['mode']
        recursive   true
        action      :create
    end
end

# File permissions
node['magento']['files'].each do |file_node, file_attr|
    file file_attr['path'] do
        content     file_attr['content']
        owner       file_attr['owner']
        group       file_attr['group']
        mode        file_attr['mode']
        action      :create
    end
end
