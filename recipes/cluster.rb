# Wrapper recipe to use when bootstrapping a cluster of Zend Servers

include_recipe "zendserver"
include_recipe "zendserver::bootstrapsingle"
include_recipe "zendserver::joincluster"