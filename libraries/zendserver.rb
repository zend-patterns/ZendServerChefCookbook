# Shared functions

require 'chef/mixin/shell_out'
include Chef::Mixin::ShellOut

# TODO: add error control
def get_node_id_by_name(name, keyname, secret)
	get_node_cmd = "#{node[:zendserver][:zsmanage]} cluster-list-servers -N #{keyname} -K #{secret} -U http://#{node[:hostname]}:10081/ZendServer/"
	p = shell_out(get_node_cmd)
	p.stdout.split(/\n/).grep(/#{name}/)[0].split(/\t/)[0]
end

def is_server_bootstrapped(keyname, secret)
  system_info = "#{node[:zendserver][:zsmanage]} system-info"
  system_info << " -N #{keyname}" unless keyname.nil? || keyname.empty?
  system_info << " -K #{secret}" unless secret.nil? || secret.empty?
  system_info << " -U http://#{node[:hostname]}:10081/ZendServer/" unless node[:hostname].nil? || node[:hostname].empty?
  
  p = shell_out(system_info)
  !p.stderr.include?  "Bootstrap is needed"
end

def is_node_joined(keyname, secret)
	system_info = "#{node[:zendserver][:zsmanage]} system-info -N #{keyname} -K #{secret} -U http://#{node[:hostname]}:10081/ZendServer/"
	p = shell_out(system_info)
	p.stdout.include?  "ZendServerCluster"
end

CHARS = ('0'..'9').to_a + ('a'..'z').to_a

def get_random_chef_admin_apikeyname ()
  apikeyname = "chef-admin-"
  apikeyname << CHARS.sort_by { rand }.join[0...8]
  apikeyname.to_s
end
