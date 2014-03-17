default['zendserver']['ext_conf_dir']  = '/usr/local/zend/etc/conf.d/'
default['zendserver']['zsmanage']  = '/usr/local/zend/bin/zs-manage'

#URL needs to have trailing slash
default['zendserver']['url'] = 'http://repos.zend.com/zend-server/'
default['zendserver']['basedirdeb'] = 'deb'
default['zendserver']['basedirrpm'] = 'rpm'

default['zendserver']['version'] = '6.1'
default['zendserver']['phpversion'] = '5.4'

# In case we want Nginx instead of Apache it has to be boolean !
default['zendserver']['nginx'] = false

# GUI default passwords
default['zendserver']['adminpassword'] = 'p2ssw0rd1'

# The order number and license 
# If needed, generate a trial license at this URL: [FILL_URL]
# The attributes have to be present, be sure to supply globally if not set here.
default['zendserver']['ordernumber'] = ''
default['zendserver']['licensekey'] = ''
default['zendserver']['production'] = 'TRUE'

# api key name and secret. Secret's length has to be 64 characters exactly.
# The attributes have to be present, be sure to supply globally if not set here.
default['zendserver']['apikeyname'] = ''
default['zendserver']['apikeysecret'] = ''

default['zendserver']['adminemail'] = ''

default['zendserver']['dbhost'] = ''
default['zendserver']['dbusername'] = ''
default['zendserver']['dbpassword'] = ''
