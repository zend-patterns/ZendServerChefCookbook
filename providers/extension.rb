require 'chef/mixin/shell_out'
require 'chef/mixin/language'
include Chef::Mixin::ShellOut

use_inline_resources if defined?(use_inline_resources)

action :enable do
	p=shell_out("#{node[:zendserver][:zsmanage]} extension-on -e #{@new_resource.name} -N #{node[:zendserver][:apikeyname]} -K #{node[:zendserver][:apikeysecret]}")
	Chef::Log.info("#{node[:zendserver][:zsmanage]} extension-on -e #{@new_resource.name} -N #{node[:zendserver][:apikeyname]} -K #{node[:zendserver][:apikeysecret]}")
	Chef::Log.debug(p.stdout)
	if p.stdout.split("\n")[1] =~ /\.?You should restart php after this action/i
		new_resource.updated_by_last_action(true)
	end
end

action :disable do
	p=shell_out("#{node[:zendserver][:zsmanage]} extension-off -e #{@new_resource} -N #{node[:zendserver][:apikeyname]} -K #{node[:zendserver][:apikeysecret]}")
	Chef::Log.info("#{node[:zendserver][:zsmanage]} extension-off -e #{@new_resource.name} -N #{node[:zendserver][:apikeyname]} -K #{node[:zendserver][:apikeysecret]}")
	Chef::Log.debug(p.stdout)
	if p.stdout.split("\n")[1] =~ /\.?You should restart php after this action/i
		new_resource.updated_by_last_action(true)
	end
end
