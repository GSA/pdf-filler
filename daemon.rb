require 'rubygems'
require 'daemons'

pwd = Dir.pwd
Daemons.run_proc('app.rb', {:dir_mode => :normal, :dir => "/var/run/sinatra"}) do
  Dir.chdir(pwd)
  exec "ruby app.rb"
end