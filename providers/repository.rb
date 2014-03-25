#
# Cookbook Name:: zend-server 
# Provider:: repository
#
# Once there is build in zypper repository support in Chef we can relay of it. 
# For now have to take care of it inside zendserver cookbook. 
#

action :add do
  if new_resource.key && (new_resource.key =~ /http/)
    execute "rpm_import_#{Digest::MD5.hexdigest(new_resource.key)}" do
      command "rpm --import #{new_resource.key}"
    end
 else
    Chef::Log.error "Can't import #{new_resource.key}"
  end

  if ::File.exists? "/etc/zypp/repos.d/rp-#{new_resource.alias}.repo"
    Chef::Log.info "Allready added #{new_resource.alias} repo config file"
  else
    Chef::Log.info "Adding #{new_resource.alias} repository config file"

    # -g option to force GPG key enabled.
    execute "zypper_addrepo_#{new_resource.alias}" do
      command "zypper addrepo -g -n '#{new_resource.title}' #{new_resource.uri} rp-#{new_resource.alias}"
    end

    new_resource.updated_by_last_action(true)
  end
end

action :remove do
  if ::File.exists? "/etc/zypp/repos.d/rp-#{new_resource.alias}.repo"
    Chef::Log.info "Removing #{new_resource.alias} repository"

    execute "zypper_removerepo_#{new_resource.alias}" do
      command "zypper removerepo rp-#{new_resource.alias}"
    end

    new_resource.updated_by_last_action(true)
  else
    Chef::Log.error "Remove failed for #{new_resource.alias}"
  end
end

action :refresh do
  if ::File.exists? "/etc/zypp/repos.d/rp-#{new_resource.alias}.repo"
    Chef::Log.info "Refreshing #{new_resource.alias} repository"

    execute "zypper_refresh_#{new_resource.alias}" do
      command "zypper refresh rp-#{new_resource.alias}"
    end

    new_resource.updated_by_last_action(true)
  else
    Chef::Log.error "Refresh failed for #{new_resource.alias}"
  end
end
