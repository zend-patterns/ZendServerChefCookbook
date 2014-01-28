# Restart in zs-manage is restart after 6.2
restart = Chef::VersionConstraint.new(">= 6.2").include?(node[:zendserver][:version]) ? "restart" : "restart-php"

execute "restart-api" do
  action :nothing
  command lazy {"#{node[:zendserver][:zsmanage]} #{restart} -N #{node[:zendserver][:chef_admin_apikeyname]} -K #{node[:zendserver][:chef_admin_apikeysecret]} "}
  retries 3
  retry_delay 3
end