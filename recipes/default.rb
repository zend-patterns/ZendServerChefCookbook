#
# Cookbook Name:: zend-server
# Recipe:: default
#
# Copyright 2013, Zend
#
# All rights reserved - Do Not Redistribute
#
include_recipe "apache2" unless node[:zendserver][:nginx]
include_recipe "apache2::mod_access_compat" unless node[:zendserver][:nginx]

version = node[:zendserver][:version]
phpversion = node[:zendserver][:phpversion]
url = node[:zendserver][:url]
basedirdeb = node[:zendserver][:basedirdeb]
basedirrpm = node[:zendserver][:basedirrpm]

package_name = "zend-server-php-#{phpversion}"
package_name = "zend-server-nginx-php-#{phpversion}" if node[:zendserver][:nginx]

case node["platform_family"]
when "debian"
  include_recipe "apt::default"
  # do things on debian-ish platforms (debian, ubuntu, linuxmint)

  Chef::Log.info("Url: #{url}#{version}/#{basedirdeb}/")

  apt_repository "zend-server" do
    uri "#{url}#{version}/#{basedirdeb}/"
    components ["server","non-free"]
    distribution ''
    key "http://repos.zend.com/zend.key"
    action :add
    notifies :run, "execute[apt-get update]", :immediately
  end

  apt_repository "nginx" do
    uri "http://nginx.org/packages/#{node['platform']}" 
    components ['nginx']
    distribution node['lsb']['codename']
    key "http://nginx.org/keys/nginx_signing.key"
    only_if { node[:zendserver][:nginx] }
  end

when "rhel"
  # do things on RHEL platforms (redhat, centos, scientific, etc)
  yum_repository "zend-server" do
    description "Zend Server repo"
    gpgkey "http://repos.zend.com/zend.key"
    url "#{url}#{version}/#{basedirrpm}/$basearch"
    action :add
  end

  yum_repository "zend-server-noarch" do
    description "Zend Server repo"
    gpgkey "http://repos.zend.com/zend.key"
    url "#{url}#{version}/#{basedirrpm}/noarch"
      action :add
  end

  yum_repository "nginx" do
    description "Nginx repo"
    gpgkey "http://nginx.org/keys/nginx_signing.key"
    url "http://nginx.org/packages/#{node['platform']}/#{node['platform_version'].split('.')[0]}/$basearch/" 
    only_if { node[:zendserver][:nginx] }
  end

  directory "/etc/httpd/conf.d" do
      action :create
  end
end

Chef::Log.info("Starting install for package #{package_name}")
package package_name do
  :install
  notifies :run, 'bash[Copy zend server vhosts]', :immediate if node[:platform_family] == "rhel"
  notifies :create, 'ruby_block[replace apache reload command]', :immediately if node[:platform_family] == "rhel"
  notifies :restart, 'service[zend-server]', :immediate
end

# To copy all Zend Server related Apache configs to conf-available
# and activate tehm using a2enconf since this is the Apache cookbook's M.O.
# Without this, the 10083 vhost required by ZS won't copy - only for RHEL
bash "Copy zend server vhosts" do
    action :nothing
    code <<-EOL
    cp /etc/httpd/conf.d/zendserver_* /etc/httpd/conf-available/ &&
    a2enconf zendserver_*
    EOL
end

# To get around the fact that Apache hangs when issued a restart
# immediately after a reload
# Block replaces reload for Apache2 only after install of ZS
# and only for RHEL
ruby_block 'replace apache reload command' do
  block do
    begin
      r = resources('service[apache2]')
      r.reload_command('/bin/true')
    rescue Chef::Exceptions::ResourceNotFound
      Chef::Log.info("service[apache2] resource not defined. Skipping restart.")
    end
  end
end

service "zend-server" do
  action :nothing
end
