node[:zendserver][:directives].each do |d, v|
  zendserver_directive d do
    value v
    notifies :run, 'execute[restart-api-if-needed]'
  end
end
