execute "restart-api" do
  action :nothing
  command "#{node[:zendserver][:zsmanage]} restart-php -N #{node[:zendserver][:apikeyname]} -K #{node[:zendserver][:apikeysecret]}"
end