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
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Required</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['zendserver']['version']</tt></td>
    <td>string</td>
    <td>Zend Server version to install</td>
    <td>Yes</td>
    <td><tt>6.2</tt></td>
  </tr>
  <tr>
    <td><tt>['zendserver']['phpversion']</tt></td>
    <td>string</td>
    <td>PHP version to install</td>
    <td>Yes</td>
    <td><tt>5.4</tt></td>
  </tr>
  <tr>
    <td><tt>['zendserver']['nginx']</tt></td>
    <td>boolean</td>
    <td>Set in you are using Nginx instead of Apache true or false boolean</td>
    <td><tt>false</tt></td>
  </tr>
  <tr>
    <td><tt>['zendserver']['ordernumber']</tt></td>
    <td>string</td>
    <td>The order number part of the license information (if not provided, will bootstrap in enterprise trial)</td>
    <td>No</td>
    <td><tt>-</tt></td>
  </tr>
  <tr>
    <td><tt>['zendserver']['licensekey']</tt></td>
    <td>string</td>
    <td>The license key part of the license information</td>
    <td>No</td>
    <td><tt>-</tt></td>
  </tr>
  <tr>
    <td><tt>['zendserver']['production']</tt></td>
    <td>boolean</td>
    <td>Bootstrap Zend Server in production (true)/development(false) mode (See zend server <a href="http://files.zend.com/help/Zend-Server/zend-server.htm#launching_zend_server.htm">documentation</a> for more details)</td>
    <td>Yes</td>
    <td><tt>TRUE</tt></td>
  </tr>
  <tr>
    <td><tt>['zendserver']['apikeyname']</tt></td>
    <td>string</td>
    <td>Name for the web API key that the installer creates. The api key is required for all management functionality</td>
    <td>Yes</td>
    <td><tt>-</tt></td>
  </tr>
  <tr>
    <td><tt>['zendserver']['apikeysecret']</tt></td>
    <td>string</td>
    <td>A 64 character key used for signing API requests</td>
    <td>Yes</td>
    <td><tt>-</tt></td>
  </tr>
  <tr>
    <td><tt>['zendserver']['adminpassword']</tt></td>
    <td>string</td>
    <td>A 4-20 character password for the admin user (use this to log into the Zend Server GUI).</a</td>
    <td>No</td>
    <td><tt>p2ssw0rd1</tt></td>
  </tr>
  <tr>
    <td><tt>['zendserver']['adminemail']</tt></td>
    <td>string</td>
    <td>An email address for the Zend Server admin</td>
    <td>No</td>
    <td><tt>-</tt></td>
  </tr>
</table>

#### zendserver::cluster
Requires all the attributes listed for single, plus a valid MySQL database.

<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Required</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['zendserver']['dbhost']</tt></td>
    <td>string</td>
    <td>A MySQL database server host address - required for clustering</td>
	<td>Yes</td>    
    <td><tt>-</tt></td>
  </tr>
  <tr>
    <td><tt>['zendserver']['dbusername']</tt></td>
    <td>string</td>
    <td>The MySQL server username, must be able to create a database - required for clustering</td>
	<td>Yes</td>    
    <td><tt>-</tt></td>
  </tr>
  <tr>
    <td><tt>['zendserver']['dbpassword']</tt></td>
    <td>string</td>
    <td>The MySQL server password - required for clustering</td>
	<td>Yes</td>    
    <td><tt>-</tt></td>
  </tr>

</table>

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


Contributing
------------

#### e.g.
  1. Fork the repository on Github
  2. Create a named feature branch (like `add_component_x`)
  3. Write your change
  4. Write tests for your change (if applicable)
  5. Run the tests, ensuring they all pass
  6. Submit a Pull Request using Github
