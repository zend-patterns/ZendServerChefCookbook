# Recipe to bootstrap a single server

include_recipe "zendserver::manage"

admin_password = node[:zendserver][:adminpassword]
order_number   = node[:zendserver][:ordernumber]
license_key	   = node[:zendserver][:licensekey]
production     = node[:zendserver][:production]
admin_email    = node[:zendserver][:adminemail]
dev_password   = node[:zendserver][:devpassword]

bs_command = "/usr/local/zend/bin/zs-manage bootstrap-single-server -p #{admin_password} -o #{order_number} -l #{license_key} -a TRUE"
bs_command << " -r #{production}" unless production.nil? || production.empty?
bs_command << " -e #{admin_email}" unless admin_email.nil? || admin_email.empty?
bs_command << " -d #{devpassword}" unless dev_password.nil? || dev_password.empty?

execute "create-api-key" do
  command "/usr/local/zend/bin/zs-manage api-keys-add-key -n #{node[:zendserver][:apikeyname]} -s #{node[:zendserver][:apikeysecret]}"
  retries 5
  retry_delay 5
  ignore_failure false
end	

execute "bootstrap-single-server" do
  command bs_command
  ignore_failure false
  notifies :run, 'execute[restart-api]'
end