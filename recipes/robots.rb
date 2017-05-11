#
# Cookbook Name:: magento
# Recipe:: robots
#

docroot            = node['magento']['docroot']
additional_domains = node['magento']['additional_domains']

cli_user           = node['magento']['cli_user']['name']
cli_group          = node['magento']['cli_user']['group']

www_user           = node['magento']['www_user']['name']
www_group          = node['magento']['www_user']['group']

# Create 'robots.txt' from template
template 'Creating robots.txt' do
    path    "#{docroot}/shared/pub/robots.txt"
    source  'robots/robots.txt.erb'
    owner   cli_user
    group   www_group
    mode    0644
    action  :create
    backup  false
    only_if {node['robots']}
end

additional_domains.each do |domain|
    template "Creating #{domain} robots.txt" do
        path    "/var/www/#{domain}/shared/pub/robots.txt"
        source  'robots/robots.txt.erb'
        owner   cli_user
        group   www_group
        mode    0644
        action  :create
        backup  false
        only_if {node['robots']}
    end
end
