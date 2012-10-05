require 'rubygems'
require 'daemons'

pwd = Dir.pwd
Daemons.run_proc('pdf-filler', {:dir_mode => :normal, :dir => "/opt/pids/sinatra"}) do
  Dir.chdir(pwd)
  exec "ruby app.rb"
end