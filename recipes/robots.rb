#
# Cookbook Name:: magento
# Recipe:: robots
#

docroot            = node['magento']['docroot']
additional_domains = node['magento']['additional_domains']

# Create 'robots.txt' from template
template 'Creating robots.txt' do
    path    "#{docroot}/shared/pub/robots.txt"
    source  'robots/robots.txt.erb'
    owner   node['magento']['users']['www']['name']
    group   node['magento']['users']['www']['group']
    mode    0644
    action  :create
    backup  false
    only_if {node['robots']}
end

additional_domains.each do |domain|
    template "Creating #{domain} robots.txt" do
        path    "/var/www/#{domain}/shared/pub/robots.txt"
        source  'robots/robots.txt.erb'
        owner   node['magento']['users']['www']['name']
        group   node['magento']['users']['www']['group']
        mode    0644
        action  :create
        backup  false
        only_if {node['robots']}
    end
end
