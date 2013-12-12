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
	system_info = "#{node[:zendserver][:zsmanage]} system-info -N #{keyname} -K #{secret} -U http://#{node[:hostname]}:10081/ZendServer/"
	p = shell_out(system_info)
	!p.stderr.include?  "Bootstrap is needed"
end

def is_node_joined(keyname, secret)
	system_info = "#{node[:zendserver][:zsmanage]} system-info -N #{keyname} -K #{secret} -U http://#{node[:hostname]}:10081/ZendServer/"
	p = shell_out(system_info)
	p.stdout.include?  "ZendServerCluster"
end
