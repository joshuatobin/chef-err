# Err cookbook

This cookbook installs [Err, a plugin based chat bot](https://github.com/gbin/err). Err supports IRC, Campfire, HipChat, Jabber and other modes of online chat.

# Requirements
* `python` community cookbook
* `git` community cookbook
* `supervisor` community cookbook

# Usage

By itself, the default recipe will create a virtual environment, install Err into it, configure Err to run as a service under [`supervisor`](http://supervisord.org/), and drop a config file that is not immediately useful.

Because chat service configuration tends to be organization-specific, this cookbook is intended to be used as a "library cookbook" within a "wrapper cookbook" that, at a minimum, overrides the default config.py template with one suitable for using Err in your organization.

*Stay tuned for an example.*

## Plugins

Plugins for Err can be automatically installed from a git repository by adding a hash to the `node['err']['plugins']` array.

Example: installing the `calcbot` plugin
```
node.default['err']['plugins'] = [
    {
      'name': 'err-calcbot',
      'repository': 'git://github.com/gbin/err-calcbot.git',
      'revision': '21060b3ed0096dbb36612d79a2492b2791376029',
      'packages': ['libqalculate-dev', 'qalc']
    }
]
```

The default recipe will iterate over plugins listed in this array and attempt to install the specified packages, as well as any requirements in `requirements.txt` at the repository root, if the file exists.

# Attributes

`install_path` - directory path where Err virtual environment and config file will live (defaults to `/opt/err/`)
`data_path` - directory path where Err will write persistent data (defaults to `/opt/err/data`)
`log_path` - directory where err.log will be written (defaults to `/opt/err/logs`)
`version` - released version of Err to be installed via pip (defaults to `1.7.1`)
`user` - username for Err to run as (defaults to `nobody`)
`group` - group for Err to run as (defaults to `nogroup`)
`runtime_options` - string of flags to be passed to Err at runtime (defaults to an empty string)
`plugins` - an array containing one or more hashes which describe the desired plugins (defaults to an empty array)


# Recipes

`default` - wrap this puppy up in a cookbook specific to your organization

# Author

Author:: Needle Ops (<cookbooks@needle.com>)
