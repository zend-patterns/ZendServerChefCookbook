name             'zendserver'
maintainer       'Zend Technologies'
maintainer_email 'maurice.k@zend.com'
license          'All rights reserved'
description      'Installs/Configures zendserver'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '1.0.0'

depends "apt"
depends "yum"
# depends "rightscale"

recipe "zendserver", "Adds the Zend Server repo and installs the package"
recipe "zendserver::single", "Install & bootstrap in 1 step"
recipe "zendserver::cluster", "Install, bootstrap and create/join a cluster in 1 step"
recipe "zendserver::manage", "Manages zend server, typically no direct actions"
recipe "zendserver::bootstrapsingle", "Bootstraps the server in single server mode"
recipe "zendserver::joincluster", "Join a Zend Server Cluster"

attribute "zendserver/url",
  :display_name => "Zend Server Base repo URL",
  :description => "The URL of the repo",
  :required => "optional",
  :default => "http://repos.zend.com/zend-server/",
  :recipes => [ 
      "zendserver::install"
  ]

attribute "zendserver/version",
  :display_name => "Zend Server version",
  :description => "The version to install - must be a valid repository version",
  :required => "optional",
  :default => "6.1",
  :recipes => [ 
      "zendserver::install"
  ]

attribute "zendserver/phpversion",
  :display_name => "PHP version",
  :description => "The PHP version to install - must be a valid PHP version for the Zend Server selected version",
  :required => "optional",
  :default => "5.4",
  :recipes => [ 
      "zendserver::install"
  ]

attribute "zendserver/adminpassword",
  :display_name => "Admin password",
  :description  => "Zend Server GUI admin password",
  :required	=> "required",
  :recipes		=> [
  	"zendserver::bootstrapsingle"
  ]

attribute "zendserver/ordernumber",
  :display_name => "Order number",
  :description  => "Zend Server license order number",
  :required	=> "required",
  :recipes		=> [
  	"zendserver::bootstrapsingle"
  ]

attribute "zendserver/licensekey",
  :display_name => "License key",
  :description  => "Zend Server license key",
  :required	=> "required",
  :recipes		=> [
  	"zendserver::bootstrapsingle"
  ]

attribute "zendserver/production",
  :display_name => "Production mode",
  :description  => "Whether to set Zend Server up as a development or production server (Monitoring rules, agregation, ...).",
  :required	=> "optional",
  :choice => ["TRUE", "FALSE"],
  :default  => "TRUE",
  :recipes		=> [
  	"zendserver::bootstrapsingle"
  ]

attribute "zendserver/apikeyname",
  :display_name => "Api key name",
  :description  => "An API key we can subsequently use",
  :required	=> "optional",
  :default  => "rightscale",
  :recipes		=> [
  	"zendserver::bootstrapsingle",
    "zendserver::manage"
  ]

attribute "zendserver/apikeysecret",
  :display_name => "Api key secret",
  :description  => "An API key secret we can sbsequenly use (64 chars)",
  :required	=> "required",
  :recipes		=> [
  	"zendserver::bootstrapsingle",
    "zendserver::manage"
  ]

attribute "zendserver/adminemail",
  :display_name => "Admin Email",
  :description  => "Administrator's email (to send alerts to)",
  :required	=> "optional",
  :recipes		=> [
  	"zendserver::bootstrapsingle"
  ]

attribute "zendserver/devpassword",
  :display_name => "Developer password",
  :description  => "Developer's account password",
  :required	=> "optional",
  :recipes		=> [
  	"zendserver::bootstrapsingle"
  ]

attribute "zendserver/dbhost",
  :display_name => "Database Host name/IP",
  :description  => "A valid MySQL database for the clustering functionality.",
  :required => "optional",
  :recipes    => [
    "zendserver::joincluster"
  ]

attribute "zendserver/dbusername",
  :display_name => "MySQL username",
  :description  => "The MySQL username",
  :required => "optional",
  :recipes    => [
    "zendserver::joincluster"
  ]

attribute "zendserver/dbpassword",
  :display_name => "MySQL password",
  :description  => "The MySQL password",
  :required => "optional",
  :recipes    => [
    "zendserver::joincluster"
  ]
