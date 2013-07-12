ENV['RACK_ENV'] = "test"
require "simplecov"
SimpleCov.start
require 'webrat'
require 'rack/test'
require "sinatra"
require 'thin'
require "./app.rb"

Webrat.configure do |conf|
  conf.mode = :rack
end

RSpec.configure do |conf|
  conf.include Rack::Test::Methods
  conf.include Webrat::Methods
  conf.include Webrat::Matchers
end