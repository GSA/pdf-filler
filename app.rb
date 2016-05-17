# app.rb
require 'rubygems'
require 'bundler/setup'

require 'sinatra'
require 'sinatra/reloader'# if development?
require 'thin'
require 'open-uri'
require 'markdown'
require 'liquid'
require 'aws-sdk'

require_relative 'lib/pdf_filler'
require_relative 'lib/storage_service'

set :root, File.dirname(__FILE__)
set :views, File.dirname(__FILE__) + "/views"

# documentation
get '/' do
  markdown :index, :layout => :bootstrap, :layout_engine => :liquid
end

# return a filled PDF as a result of post data
post '/fill' do
  remote_pdf = params['pdf']
  pdf = PdfFiller.new.fill( remote_pdf, params ).path
  send_file pdf,
    disposition: :inline,
    type:        "application/pdf",
    filename:    File.basename(params['pdf'])
end

# Store a pdf using the StorageService - return the url
get '/store' do
  authorized! do |creds|
    pdf = PdfFiller.new.fill( params['pdf'], params )
    storer = StorageService.new(creds)
    storer.store(pdf, params)
  end
end

# get an HTML listing of all the fields
# e.g., /fields.html?pdf=http://help.adobe.com/en_US/Acrobat/9.0/Samples/interactiveform_enabled.pdf
get '/fields' do
  liquid :fields, :locals => { :pdf => params['pdf'], :fields => PdfFiller.new.get_fields( params['pdf'] ) }, :layout => :bootstrap
end

# return JSON list of field names
# e.g., /fields.json?pdf=http://help.adobe.com/en_US/Acrobat/9.0/Samples/interactiveform_enabled.pdf
get '/fields.json' do
  PdfFiller.new.get_fields( params['pdf'] ).to_json
end

# get an HTML representation of the form
# e.g., /form.html?pdf=http://help.adobe.com/en_US/Acrobat/9.0/Samples/interactiveform_enabled.pdf
get '/form' do
  liquid :form, :locals => { :pdf => params['pdf'], :fields => PdfFiller.new.get_fields( params['pdf'] ) }, :layout => :bootstrap
end

def authorized!
  auth_token = request.env['HTTP_AUTHORIZATION']
  if auth_token && creds = authorized?(auth_token)
    yield creds
  else
    raise AuthorizationError.new("authorization token not found")
  end
end

def authorized? token
  ENV['AUTHORIZATION_TOKEN'] = 'abc'
  ENV['AWS_ACCESS_KEY_ID'] = 'AKIAIERGCPBMD2PHIR4Q'
  ENV['AWS_SECRET_ACCESS_KEY'] = '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'

  if ENV['AUTHORIZATION_TOKEN'] == token
    {
      aws_access_key_id: ENV['AWS_ACCESS_KEY_ID'],
      aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
    }
  end
end

class AuthorizationError < StandardError; end
