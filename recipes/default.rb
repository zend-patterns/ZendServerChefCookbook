#
# Cookbook Name:: zend-server
# Recipe:: default
#
# Copyright 2013, Zend
#
# All rights reserved - Do Not Redistribute
#
include_recipe "apache2" unless node[:zendserver][:nginx]

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

  log "Url: #{url}#{version}/#{basedirdeb}/"

  apt_repository "zend-server" do
    uri "#{url}#{version}/#{basedirdeb}/"
    components ["server","non-free"]
    key "http://repos.zend.com/zend.key"
    action :add
    notifies :run, "execute[apt-get update]", :immediately
  end

  apt_repository "nginx" do
    uri "http://nginx.org/packages/#{node['platform']}" 
    components [node['lsb']['codename'], 'nginx']
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

log "Starting install for package #{package_name}"
package package_name do
  :install
  notifies :run, 'bash[Copy zend server vhosts]', :immediate if node[:platform_family] == "rhel"
  notifies :restart, 'service[zend-server]', :immediate
end

bash "Copy zend server vhosts" do
    action :nothing
    code <<-EOL
    cp /etc/httpd/conf.d/zendserver_* /etc/httpd/conf-available/ &&
    a2enconf zendserver_*
    EOL
end

service "zend-server" do
  action :nothing
end
