# Restart in zs-manage is restart after 6.2
# restart = Chef::VersionConstraint.new(">= 6.2").include?(node[:zendserver][:version]) ? "restart" : "restart-php"
restart = "restart"

key_name 	 = node[:zendserver][:apikeyname]
key_secret   = node[:zendserver][:apikeysecret]

execute "restart-api" do
  action :nothing
  command "#{node[:zendserver][:zsmanage]} #{restart} -N #{node[:zendserver][:apikeyname]} -K #{node[:zendserver][:apikeysecret]}"
  retries 3
  retry_delay 3
end

execute "restart-api-if-needed" do
  action :nothing
  only_if { is_restart_needed(key_name, key_secret) }
  command "#{node[:zendserver][:zsmanage]} #{restart} -N #{node[:zendserver][:apikeyname]} -K #{node[:zendserver][:apikeysecret]}"
  retries 3
  retry_delay 3
end

bash "wait-for-db-connection" do
  action :nothing
  code <<-EOH
  while :; do if [ -z `/usr/local/zend/bin/zs-manage system-info -N develop -K BDUFCMmCGTi2bZFqDn8rATUiTRSSdbQX3SdwKHwDkMJd2hX47LYcOtb8iTLCf2iG -U http://dev-green-webs:10081/ZendServer/ 2>&1 | grep 'databaseConnectionError' | awk -F ":" '{print $2}'` ] ; then break; else echo 'no db'; fi; sleep 1; done ;
  EOH
end

bash "restart-api-and-wait-for-ok" do
    code <<-EOH
    #{node[:zendserver][:zsmanage]} #{restart} -N #{node[:zendserver][:apikeyname]} -K #{node[:zendserver][:apikeysecret]}
    sleep 3
    while :; do if [ `/usr/local/zend/bin/zs-manage system-info -N #{node[:zendserver][:apikeyname]} -K #{node[:zendserver][:apikeysecret]} | head -n 1 | awk '{print $4}'` != "pendingRestart" ] ; then break; fi; sleep 1; done;
    EOH
    action :nothing
end

execute "config-apply-changes" do
    action :nothing
    command "/usr/local/zend/bin/zs-manage config-apply-changes -N #{node[:zendserver][:apikeyname]} -K #{node[:zendserver][:apikeysecret]} | head -n 1 | awk '{print $2}'; sleep 3;"
    notifies :run, "execute[restart-api]", :immediate
end
