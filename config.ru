require "rubygems"
require 'bundler'
Bundler.setup

require "sinatra"
require 'thin'
require "./app.rb"

run Sinatra::Application
