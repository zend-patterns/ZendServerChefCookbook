# Remoev a node from a cluster

key_name 	 = node[:zendserver][:apikeyname]
key_secret   = node[:zendserver][:apikeysecret]

node_id = get_node_id_by_name(node['hostname'], key_name, key_secret)
unjoin_command = "#{node[:zendserver][:zsmanage]} cluster-remove-server #{node_id} -N #{key_name} -K #{key_secret} -s"

log "Removing server node #{node['hostname']} from cluster"

execute "cluster-unjoin-server" do
	command unjoin_command
	ignore_failure false
end