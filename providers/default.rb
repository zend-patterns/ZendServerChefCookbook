# Stop Zend Server
action :stop do
  log "  Running stop sequence"
  service "zend-server" do
    action :stop
    persist false
  end
end

# Start Zend Server
action :start do
  log "  Running start sequence"
  service "zend-server" do
    action :start
    persist false
  end
end

# Restart apache
action :restart do
  action_stop
  sleep 5
  action_start
end