require 'chef/mixin/shell_out'
require 'chef/mixin/language'
include Chef::Mixin::ShellOut

use_inline_resources if defined?(use_inline_resources)

action :store do
	p=shell_out("#{node[:zendserver][:zsmanage]} store-directive -d '#{@new_resource.key}' -v '#{@new_resource.value}' -N #{node[:zendserver][:apikeyname]} -K #{node[:zendserver][:apikeysecret]}")
	Chef::Log.info("Storing directive #{@new_resource.key} having value #{@new_resource.value}")
	Chef::Log.debug("#{node[:zendserver][:zsmanage]} store-directive -d '#{@new_resource.key}' -v '#{@new_resource.value}' -N #{node[:zendserver][:apikeyname]} -K #{node[:zendserver][:apikeysecret]}")
	Chef::Log.debug(p.stdout)
	if p.stdout.split("\n")[1] =~ /\.?You should restart php or any other components affected by this change/i
	    new_resource.updated_by_last_action(true)
	end
end
