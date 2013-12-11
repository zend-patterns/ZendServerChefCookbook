# Restart in zs-manage is restart after 6.2
restart = Chef::VersionConstraint.new(">= 6.2").include?(node[:zendserver][:version]) ? "restart" : "restart-php"

execute "restart-api" do
  action :nothing
  command "#{node[:zendserver][:zsmanage]} #{restart} -N #{node[:zendserver][:apikeyname]} -K #{node[:zendserver][:apikeysecret]}"
  retries 3
  retry_delay 3
end