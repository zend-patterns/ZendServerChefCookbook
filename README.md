zendserver Cookbook
====================
This cookbook installs and manages Zend Server

It allows bootstrapping Zend Server in single server mode or cluster mode.

Requirements
------------

#### Platforms
- Debian, Ubuntu
- RHEL, CentOS, Oracle Linux

#### Cookbooks
- aptitude
- yum

Attributes
----------

#### zendserver::single
Key | Type | Description | Required | Default
--- | --- | --- | --- | --- |
`['zendserver']['version']` | string | Zend Server version to install | Yes | `6.1`
`['zendserver']['phpversion']` | string | PHP version to install | Yes | `5.4`
`['zendserver']['nginx']` | boolean| Set in you are using Nginx instead of Apache true or false boolean | No | `false`
`['zendserver']['ordernumber']` | string | The order number part of the license information (if not provided, will bootstrap in enterprise trial) | No | `-`
`['zendserver']['licensekey']` | string | The license key part of the license information | No | `-`
`['zendserver']['production']` | boolean | Bootstrap Zend Server in production (true)/development(false) mode (See zend server <a href="http://files.zend.com/help/Zend-Server/zend-server.htm#launching_zend_server.htm">documentation</a> for more details) | Yes | `TRUE`
`['zendserver']['apikeyname']` | string | Name for the web API key that the installer creates. The api key is required for all management functionality | Yes | `-`
`['zendserver']['apikeysecret']` | string | A 64 character key used for signing API requests | Yes | `-`
`['zendserver']['adminpassword']` | string | A 4-20 character password for the admin user (use this to log into the Zend Server GUI) | No | `p2ssw0rd1`
`['zendserver']['adminemail']` | string | An email address for the Zend Server admin | No | `-`

#### zendserver::cluster
Requires all the attributes listed for single, plus a valid MySQL database.

Key | Type | Description | Required | Default
--- | --- | --- | --- | --- |
`['zendserver']['dbhost']`     | string | A MySQL database server host address - required for clustering | Yes | `-`
`['zendserver']['dbusername']` | string | The MySQL server username, must be able to create a database - required for clustering | Yes | `-`
`['zendserver']['dbpassword']` | string | The MySQL server password - required for clustering | Yes | `-`
`['zendserver']['dbname']`     | string | The MySQL server database name - required for clustering | No | `ZendServer`

Recipes
-------
#### zendserver::single
Installs Zend Server, and bootstraps in single server mode

Just include `zendserver` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[zendserver::single]"
  ]
}
```

#### zendserver::cluster
Installs Zend Server, and bootstraps in cluster mode

Just include `zendserver` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[zendserver::cluster]"
  ]
}
```

Providers
---------
#### zendserver_extension - Enabling/disabling extensions

In your cookbook, in a recipe:

```ruby
include_recipe "zendserver"

zendserver_extension "mongo" do
	action :enable
	notifies :restart, 'service[zend-server]'
end
```

To enable many extensions without repeating the code block:
```ruby
include_recipe "zendserver"

["mongo", "memcached", "mssql"].each do |ext|
	zendserver_extension ext do
		action :enable
		notifies :restart, 'service[zend-server]'
	end
end
```

Notice the notification - By default the action will not restart the server, the recommended way to restart is to add the notification (They will be queued up, and only one restart will occur at the end).

#### zendserver_directive - Set ini directive values

In your wrapper cookbook, use in a recipe:

```ruby
include_recipe "zendserver"

zendserver_directive "error_reporting" do
  value "E_ALL"
  notifies :restart, 'service[zend-server]'
end
```

You probably want to set more directives, so it's reasonable to define a hash of directives in a role, environment or default attributes and set them in one go like this:

Set the attributes:

```json
{
  ...,
  "default_attributes": {
    "zendserver": {
      "directives": {
		"error_reporting": "E_ALL",
		"display_errors": "0",
		"display_startup_errors": "0"
      }
    }
  },
  ...
}
```

Use the attributes hash to set the directives: 

```ruby
include_recipe "zendserver"

node[:zendserver][:directives].each do |d, v|
  zendserver_directive d do
    value v
    notifies :restart, 'service[zend-server]'
  end
end
```

Contributing
------------

#### e.g.
  1. Fork the repository on Github
  2. Create a named feature branch (like `add_component_x`)
  3. Write your change
  4. Write tests for your change (if applicable)
  5. Run the tests, ensuring they all pass
  6. Submit a Pull Request using Github
