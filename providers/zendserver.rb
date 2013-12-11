# Shared functions

require 'chef/mixin/shell_out'
include Chef::Mixin::ShellOut

# TODO: add error control
def get_node_id_by_name(name, keyname, secret)
	get_node_cmd = "#{node[:zendserver][:zsmanage]} cluster-list-servers -N #{keyname} -K #{secret}"
	p = shell_out(get_node_cmd)
	p.split(/\n/).grep(/\t#{name}\t/)[0].split(/\t/)[0]
end
