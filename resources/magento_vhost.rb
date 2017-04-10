resource_name :magento_vhost

property :magento_vhost, String, name_property: true
property :docroot, String, required: true
property :fpm_location, String, required: true

property :nginx_listen, String, required: false, default: '80'
property :mage_run_code, String, required: false
property :mage_run_type, String, required: false

default_action :create

action :create do
    template "#{node['nginx']['vhost_dir']}/#{magento_vhost}.conf" do
        variables({
            :nginx_listen  => nginx_listen,
            :hostname      => magento_vhost,
            :docroot       => docroot,
            :fpm_location  => fpm_location,
            :mage_run_code => mage_run_code,
            :mage_run_type => mage_run_type,
        })
        cookbook 'cop_magento'
        source   "nginx/mage.nginx.vhost.conf.erb"
        owner    'root'
        group    'root'
        mode     0644
        backup   false
        action   :create
        notifies :restart, 'service[nginx]', :delayed
    end

    service 'nginx' do
        action :nothing
    end
end

action :delete do
    file "#{node['nginx']['vhost_dir']}/#{magento_vhost}.conf" do
        backup   false
        action   :delete
        notifies :restart, 'service[nginx]', :delayed
    end

    service 'nginx' do
        action :nothing
    end
end
