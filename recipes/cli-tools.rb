#
# Cookbook Name:: magento
# Recipe:: cli-tools
#

node['magento']['tools'].each do |tool_node, tool_attr|
    cookbook_file tool_attr['path'] do
        source  tool_attr['source']
        owner   tool_attr['owner']
        group   tool_attr['group']
        mode    tool_attr['mode']
        action  :create
    end
end
