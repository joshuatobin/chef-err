default['err']['install_path'] = '/opt/err'
default['err']['data_path'] = '/opt/err/data'
default['err']['logfile_path'] = '/opt/err/logs/err.log'
default['err']['loglevel'] = "INFO"
default['err']['plugin_path'] = '/opt/err/plugins'
default['err']['version'] = '1.7.1'
default['err']['user'] = 'nobody'
default['err']['group'] = 'nogroup'
# Pass flags like -H, -X, -C or -I (hipchat, xmpp, campfire or IRC) in 'runtime_options'
default['err']['runtime_options'] = String.new
default['err']['plugins'] = Array.new
default['err']['async'] = false

default['err']['full_name'] = 'Err'
default['err']['username'] = 'err@localhost'
default['err']['password'] = 'changeme'
default['err']['token'] = undef
default['err']['rooms'] = ['err@conference.example.com']
default['err']['admins'] = ['gbin@localhost']
default['err']['command_prefix'] = '!'
default['err']['additional_prefixes'] = [ 'Err', 'err' ]
default['err']['prefix_separators'] = [ ':', ',', ';' ]
default['err']['prefix_case_insensitive'] = true
# sentry
default['err']['sentry']['enabled'] = false
default['err']['sentry']['dsn'] = String.new
default['err']['sentry']['loglevel'] = 'ERROR'
