require "rubygems"
require 'bundler'
Bundler.setup

require "sinatra"
require "sinatra/reloader" if development?
require 'thin'
require "./app.rb"

run Sinatra::Application
