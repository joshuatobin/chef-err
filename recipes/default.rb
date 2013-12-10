#
# Cookbook Name:: errbot
# Recipe:: default
#
# Copyright (C) 2013 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'git'
include_recipe 'python'
include_recipe 'supervisor'

ruby_block "err_service_trigger" do
  block do
    # err service action trigger for LWRP's
  end
  action :nothing
end

%w{ install_path data_path plugin_path }.each do |dir|
  directory node['err'][dir] do
    owner node['err']['user']
    group node['err']['group']
    recursive true
  end
end

if node['err']['logfile_path']
  directory ::File.dirname(node['err']['logfile_path']) do
    owner node['err']['user']
    group node['err']['group']
    recursive true
  end
end

directory ::File.join(node['err']['data_path'],'plugins') do
  owner node['err']['user']
  group node['err']['group']
  recursive true
end

err_virtualenv = ::File.join(node['err']['install_path'],'env')

python_virtualenv err_virtualenv do
  owner node['err']['user']
  group node['err']['group']
  action :create
end

python_pip "xmpppy" do
  version "0.5.0rc1"
  virtualenv err_virtualenv
end

python_pip "err" do
  version node['err']['version']
  virtualenv err_virtualenv
end

node.run_state['err_plugin_paths'] ||= Array.new

node['err']['plugins'].each do |plugin|
  err_plugin plugin['name'] do
    plugin_path node['err']['plugin_path']
    virtualenv err_virtualenv
    repository plugin['repository']
    revision plugin['revision']
    user node['err']['user']
    group node['err']['group']
    packages plugin['packages']
    notifies :create, "ruby_block[err_service_trigger]", :immediately
    action :install
  end
end

# we'll drop off a default-ish config.py for you
# but it is recommended that you wrap this cookbook in
# a cookbook of your own which overrides this template
# with a config that meets your specific needs
template ::File.join(node['err']['install_path'],'config.py') do
  source 'config.py.erb'
  owner node['err']['user']
  group node['err']['group']
  mode 0640
  notifies :create, "ruby_block[err_service_trigger]", :immediately
  variables({
    :plugin_paths => node['err']['plugin_path']
  })
end

base_command = ::File.join(err_virtualenv,'bin','err.py')

supervisor_service 'err' do
  action :enable
  command "#{base_command} #{node['err']['runtime_options']} -c #{node['err']['install_path']} -u #{node['err']['user']} -g #{node['err']['group']}"
  subscribes :restart, resources("ruby_block[err_service_trigger]"), :delayed
end
