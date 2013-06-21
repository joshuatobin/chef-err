actions :install

attribute :plugin_path, :kind_of => String, :required => true
attribute :virtualenv, :kind_of => [NilClass, String], :default => nil
attribute :repository, :kind_of => String, :required => true
attribute :revision, :kind_of => String, :default => "HEAD"
attribute :user, :kind_of => [NilClass, String], :default => nil
attribute :group, :kind_of => [NilClass, String], :default => nil
attribute :packages, :kind_of => Array, :default => []
attribute :git_action, :default => :sync

def initialize(*args)
  super
  @action = :install
end
