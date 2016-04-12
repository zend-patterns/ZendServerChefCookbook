if node[:zendserver].attribute?(:java_package)
    package node[:zendserver][:java_package] do
        action :install
    end
end

execute "echo java-daemon-zend-server java-daemon-zend-server/config_java boolean true | sudo debconf-set-selections" do
    action :run
end

# Install package
package "php-#{node[:zendserver][:phpversion]}-java-bridge-zend-server" do
    action :install
end

# Set configured classpath
template "/usr/local/zend/etc/watchdog-jb.ini" do
    source "watchdog-jb.ini.erb"
    variables({
        :classpath => node[:zendserver][:java_classpath]
    })
    notifies :restart, 'service[zend-server]', :delayed
end
