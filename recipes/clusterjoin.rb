include_recipe "zendserver::manage"
include_recipe "zendserver::bootstrapsingle"

key_name 	 = node[:zendserver][:apikeyname]
key_secret   = node[:zendserver][:apikeysecret]
db_host 	 = nore[:zendserver][:dbhost]
db_user 	 = nore[:zendserver][:dbusername]
db_pass 	 = nore[:zendserver][:dbpassword]

# check before install that a suitable key is provided, if not bail out
Chef::Application.fatal!("Zend Server db_host missing", 2) if db_host.nil? || db_host.empty?
Chef::Application.fatal!("Zend Server db_user missing", 2) if db_user.nil? || db_user.empty?
Chef::Application.fatal!("Zend Server db_pass missing", 2) if db_pass.nil? || db_pass.empty?

join_command = "#{node[:zendserver][:zsmanage]} cluster-add-to-server -N #{key_name} -K #{key_secret} -n #{node['hostname']} -i #{node['ipaddress']} -o #{db_host} -u #{db_user} -p #{db_pass} -s"

execute "cluster-join-server" do
	log "Adding server node to cluster"
	command join_command
	ignore_failure false
end