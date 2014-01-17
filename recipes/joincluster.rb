#This recipe is used to join a cluster of Zend Servers

key_name 	 = node[:zendserver][:apikeyname]
key_secret   = node[:zendserver][:apikeysecret]
db_host 	 = node[:zendserver][:dbhost]
db_user 	 = node[:zendserver][:dbusername]
db_pass 	 = node[:zendserver][:dbpassword]
node_ip      = node[:zendserver][:node_ip].nil? ? node['ipaddress'] : node[:zendserver][:node_ip]

Log "Using ip: #{node_ip}"

# check before install that a suitable key is provided, if not bail out
Chef::Application.fatal!("Zend Server db_host missing", 2) if db_host.nil? || db_host.empty?
Chef::Application.fatal!("Zend Server db_user missing", 2) if db_user.nil? || db_user.empty?
Chef::Application.fatal!("Zend Server db_pass missing", 2) if db_pass.nil? || db_pass.empty?

join_command = "#{node[:zendserver][:zsmanage]} server-add-to-cluster -N #{key_name} -K #{key_secret} -U http://#{node[:hostname]}:10081/ZendServer/ -n #{node['hostname']} -i #{node_ip} -o #{db_host} -u #{db_user} -p #{db_pass} -s"

execute "cluster-join-server" do
	command join_command
	ignore_failure false
	retries 5
	retry_delay 3
	not_if { is_node_joined(key_name, key_secret) }
end
