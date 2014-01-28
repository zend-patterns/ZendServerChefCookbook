#This recipe is used to join a cluster of Zend Servers

ruby_block "server add to cluster" do
  block do
    apikeyname       = node[:zendserver][:chef_admin_apikeyname]
    apikeysecret     = node[:zendserver][:chef_admin_apikeysecret]   
    dbhost           = node[:zendserver][:dbhost]
    dbusername       = node[:zendserver][:dbusername]
    dbpassword       = node[:zendserver][:dbpassword]
    node_ip          = node[:zendserver][:node_ip].nil? ? node['ipaddress'] : node[:zendserver][:node_ip]

    # check before install that a suitable key is provided, if not bail out
    Chef::Application.fatal!("Zend Server API Key Name missing", 2) if apikeyname.nil? || apikeyname.empty?
    Chef::Application.fatal!("Zend Server API Key Secret missing", 2) if apikeysecret.nil? || apikeysecret.empty? || apikeysecret == "00000"
    Chef::Application.fatal!("Zend Server dbhost missing", 2) if dbhost.nil? || dbhost.empty?
    Chef::Application.fatal!("Zend Server dbhost missing", 2) if dbhost.nil? || dbhost.empty?
    Chef::Application.fatal!("Zend Server dbusername missing", 2) if dbusername.nil? || dbusername.empty?
    Chef::Application.fatal!("Zend Server dbpassword missing", 2) if dbpassword.nil? || dbpassword.empty?
    
    join_command = "#{node[:zendserver][:zsmanage]} server-add-to-cluster -N #{apikeyname} -K #{apikeysecret} -n #{node['hostname']} -i #{node_ip} -o #{dbhost} -u #{dbusername} -p #{dbpassword} -s"
    p = Chef::Mixin::ShellOut.shell_out(join_command)
    
    node.set[:zendserver][:chef_admin_apikeyname] = p.stdout.split(/\n/).grep(/WEB_API_KEY/)[0].split(/=/)[1].strip()
    node.set[:zendserver][:chef_admin_apikeysecret] = p.stdout.split(/\n/).grep(/WEB_API_KEY_HASH/)[0].split(/=/)[1].strip()
  end
  not_if { is_node_joined(node[:zendserver][:chef_admin_apikeyname], node[:zendserver][:chef_admin_apikeysecret]) }
end