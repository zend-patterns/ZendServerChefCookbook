#
# Cookbook Name:: zend-server
# Recipe:: default
#
# Copyright 2013, Zend
#
# All rights reserved - Do Not Redistribute
#
version = node[:zendserver][:version]
phpversion = node[:zendserver][:phpversion]
url = node[:zendserver][:url]
basedirdeb = node[:zendserver][:basedirdeb]
basedirrpm = node[:zendserver][:basedirrpm]

case node[:zendserver][:nginx]
when true 
package_name = "zend-server-nginx-php-#{phpversion}"
when false
package_name = "zend-server-php-#{phpversion}"
else
package_name = "zend-server-php-#{phpversion}"
end

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
when "rhel"
  yum_key "zend-server" do
    url "http://repos.zend.com/zend.key"
    action :add
  end

  # do things on RHEL platforms (redhat, centos, scientific, etc)
  yum_repository "zend-server" do
  description "Zend Server repo"
  url "#{url}/#{version}/#{basedirrpm}/$basearch"
    action :add
  end

  yum_repository "zend-server-noarch" do
  description "Zend Server repo"
  url "#{url}/#{version}/#{basedirrpm}/noarch"
    action :add
  end
end

log "Starting install for package #{package_name}"
package package_name do
  :install
  notifies :restart, 'service[zend-server]', :immediate if node["platform_family"] == "rhel"
end

# Problem with CentOS api functions if server not restarted
service "zend-server" do
  action :nothing
end