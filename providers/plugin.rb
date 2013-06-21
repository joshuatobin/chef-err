# Lifted from the Python community cookbook, on which we depend
def which_pip(nr)
  if (nr.respond_to?("virtualenv") && nr.virtualenv)
    ::File.join(nr.virtualenv,'/bin/pip')
  elsif node['python']['install_method'].eql?("source")
    ::File.join(node['python']['prefix_dir'], "/bin/pip")
  else
    'pip'
  end
end

action :install do

  Chef::Log.debug("Err: installing packages for #{new_resource.name} plugin: #{new_resource.packages.inspect}")
  new_resource.packages.each do |pkg|
    package pkg do
      action :install
    end
  end

  plugin_path = ::File.join(new_resource.plugin_path, new_resource.name)
  pip_cmd = which_pip(new_resource)
  reqs = ::File.join(plugin_path, 'requirements.txt')

  Chef::Log.debug("Err: installing any required python modules based on requirements.txt")
  execute "install #{new_resource.name} plugin requirements" do
    command <<-EOH
    if [ -f #{reqs} ];
    then
      echo "Installing plugin requirements from #{reqs}"
      #{pip_cmd} install -r #{reqs}
    else
      echo "No requirements file found at #{reqs}"
    fi
    EOH
    cwd plugin_path
    action :nothing
  end

  Chef::Log.debug("Err: syncing plugin #{new_resource.name} from #{new_resource.repository}, revision #{new_resource.revision}")
  plug = git plugin_path do
    repository new_resource.repository
    revision new_resource.revision
    user new_resource.user if new_resource.user
    group new_resource.group if new_resource.group
    notifies :run, "execute[install #{new_resource.name} plugin requirements]", :immediately
  end

  Chef::Log.debug("Err: adding path #{plugin_path} to node.run_state['err_plugin_paths']")
  node.run_state['err_plugin_paths'] ||= Array.new
  node.run_state['err_plugin_paths'] << plugin_path

  new_resource.updated_by_last_action(plug.updated_by_last_action?)
end
