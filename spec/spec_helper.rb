require 'rack/test'
require 'rspec'

ENV['RACK_ENV'] = "test"

require "simplecov"
SimpleCov.start

require 'webrat'

require_relative "../app.rb"

module RSpecMixin
  include Rack::Test::Methods
  include Webrat::Matchers
  def app
    Sinatra::Application
  end
end

RSpec.configure do |conf|
  conf.include RSpecMixin

  conf.expect_with(:rspec) do |c|
    c.syntax = [:should, :expect]
  end
end
