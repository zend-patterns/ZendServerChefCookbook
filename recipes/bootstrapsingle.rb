# Recipe to bootstrap a single server

include_recipe "zendserver::manage"

admin_password = node[:zendserver][:adminpassword]
order_number   = node[:zendserver][:ordernumber]
license_key	   = node[:zendserver][:licensekey]
production     = node[:zendserver][:production]
admin_email    = node[:zendserver][:adminemail]
dev_password   = node[:zendserver][:devpassword]

bs_command = "/usr/local/zend/bin/zs-manage bootstrap-single-server -p #{admin_password} -a TRUE"
bs_command << " -o #{order_number}" unless order_number.nil? || order_number.empty?
bs_command << " -l #{license_key}" unless license_key.nil? || license_key.empty?
bs_command << " -r #{production}" unless production.nil? || production.empty?
bs_command << " -e #{admin_email}" unless admin_email.nil? || admin_email.empty?
bs_command << " -d #{devpassword}" unless dev_password.nil? || dev_password.empty?


execute "create-api-key" do
  command "/usr/local/zend/bin/zs-manage api-keys-add-key -n #{node[:zendserver][:apikeyname]} -s #{node[:zendserver][:apikeysecret]}"
  retries 5
  retry_delay 5
  ignore_failure false
  not_if { is_server_bootstrapped(node[:zendserver][:apikeyname], node[:zendserver][:apikeysecret]) }
end	

execute "bootstrap-single-server" do
  command bs_command
  ignore_failure false
  notifies :run, 'execute[restart-api]'
  not_if { is_server_bootstrapped(node[:zendserver][:apikeyname], node[:zendserver][:apikeysecret]) }
end
