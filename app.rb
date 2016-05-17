# app.rb
require 'rubygems'
require 'bundler/setup'

require 'sinatra'
require 'sinatra/reloader'# if development?
require 'thin'
require 'liquid'
require 'aws-sdk'

require_relative 'lib/pdf_filler'
require_relative 'lib/storage_service'

set :root, File.dirname(__FILE__)
set :views, File.dirname(__FILE__) + "/views"

# documentation
get '/' do
  markdown :index,
            layout: :bootstrap,
            layout_engine: :liquid
end

# get an HTML listing of all the fields
# e.g., /fields.html?pdf=http://help.adobe.com/en_US/Acrobat/9.0/Samples/interactiveform_enabled.pdf
get '/fields' do
  liquid  :fields,
          locals: {
            pdf: params['pdf'],
            fields: fields(params)
          },
          layout: :bootstrap
end

# return JSON list of field names
# e.g., /fields.json?pdf=http://help.adobe.com/en_US/Acrobat/9.0/Samples/interactiveform_enabled.pdf
get '/fields.json' do
  fields(params).to_json
end

# return a filled PDF as a result of post data
post '/fill' do
  send_file fill(params).path,
    disposition: :inline,
    type:        "application/pdf",
    filename:    File.basename(params['pdf'])
end

# get an HTML representation of the form
# e.g., /form.html?pdf=http://help.adobe.com/en_US/Acrobat/9.0/Samples/interactiveform_enabled.pdf
get '/form' do
  liquid :form,
          locals: {
            pdf: params['pdf'],
            fields: fields(params)
          },
          layout: :bootstrap
end

# Fill and store a pdf using the StorageService - return the url of the stored file
get '/store' do
  authorized! do |creds|
    storer = StorageService.new(creds)
    storer.store(fill(params).path, params)
  end
end

##### HELPER METHODS: #####

def authorized!
  auth_token = request.env['HTTP_AUTHORIZATION']
  if auth_token && creds = authorized?(auth_token)
    yield creds
  else
    raise AuthorizationError.new("authorization token not found")
  end
end

def authorized? token
  if ENV['AUTHORIZATION_TOKEN'] == token
    {
      aws_access_key_id:     ENV['AWS_ACCESS_KEY_ID'],
      aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
      aws_s3_bucket:         ENV['AWS_S3_BUCKET'],
      aws_s3_acl:            ENV['AWS_S3_ACL']
    }
  end
end

def fill params
  PdfFiller.new.fill( params['pdf'], params )
end

def fields params
  PdfFiller.new.get_fields( params['pdf'] )
end

class AuthorizationError < StandardError; end
