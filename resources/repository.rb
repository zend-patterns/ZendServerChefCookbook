#
# Cookbook Name:: zend-server
# Resource:: repository
#


actions :add, :remove, :refresh

attribute :alias, :kind_of => String, :name_attribute => true
attribute :uri, :kind_of => String
attribute :title, :kind_of => String
attribute :keyserver, :kind_of => String, :default => nil
attribute :key, :kind_of => String, :default => nil

default_action :add
