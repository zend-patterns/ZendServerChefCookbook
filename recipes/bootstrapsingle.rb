node.default[:zendserver][:chef_admin_apikeyname] = "chef-admin-12345678"
node.default[:zendserver][:chef_admin_apikeysecret] = "00000"
  
ruby_block "set chef admin api credentials" do
  block do
    node.set[:zendserver][:chef_admin_apikeyname] = get_random_chef_admin_apikeyname()
    set_api = "#{node[:zendserver][:zsmanage]} api-keys-add-key -n #{node[:zendserver][:chef_admin_apikeyname]} -u admin"
    p = Chef::Mixin::ShellOut.shell_out(set_api)
    
    node.set[:zendserver][:chef_admin_apikeysecret] = p.stdout.split(/\n/).grep(/KEY_HASH/)[0].split(/=/)[1].strip()
  end
  notifies :run, "execute[bootstrap-single-server]", :immediately
  not_if { is_server_bootstrapped(node[:zendserver][:chef_admin_apikeyname], node[:zendserver][:chef_admin_apikeysecret]) }
end
  
include_recipe "zendserver::manage"
  
admin_password = node[:zendserver][:adminpassword]
order_number   = node[:zendserver][:ordernumber]
license_key    = node[:zendserver][:licensekey]
production     = node[:zendserver][:production]
admin_email    = node[:zendserver][:adminemail]
dev_password   = node[:zendserver][:devpassword]

bs_command = "/usr/local/zend/bin/zs-manage bootstrap-single-server -p #{admin_password} -a TRUE"
bs_command << " -o #{order_number}" unless order_number.nil? || order_number.empty?
bs_command << " -l #{license_key}" unless license_key.nil? || license_key.empty?
bs_command << " -r #{production}" unless production.nil? || production.empty?
bs_command << " -e #{admin_email}" unless admin_email.nil? || admin_email.empty?
bs_command << " -d #{devpassword}" unless dev_password.nil? || dev_password.empty?

execute "bootstrap-single-server" do
  command lazy {bs_command}
  ignore_failure false
  notifies :run, 'execute[restart-api]', :delayed
  action :nothing
end