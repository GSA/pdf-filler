# app.rb
require 'rubygems'
require 'sinatra'
require 'thin'
require 'open-uri'
require 'markdown'
require 'liquid'
require File.dirname(__FILE__) + "/lib/pdf_filler.rb"

set :root, File.dirname(__FILE__)
set :views, File.dirname(__FILE__) + "/views"

# documentation
get '/' do 
  markdown :index, :layout => :bootstrap, :layout_engine => :liquid
end

# return a filled PDF as a result of post data
post '/fill' do
  pdf = PdfFiller.new
  send_file pdf.fill( params['pdf'], params ).path
end

# get an HTML listing of all the fields
# e.g., /fields.html?pdf=http://help.adobe.com/en_US/Acrobat/9.0/Samples/interactiveform_enabled.pdf
get '/fields' do
  pdf = PdfFiller.new
  liquid :fields, :locals => { :pdf => params['pdf'], :fields => pdf.get_fields( params['pdf'] ) }, :layout => :bootstrap
end

# return JSON list of field names
# e.g., /fields.json?pdf=http://help.adobe.com/en_US/Acrobat/9.0/Samples/interactiveform_enabled.pdf
get '/fields.json' do
  pdf = PdfFiller.new
  pdf.get_fields( params['pdf'] ).to_json
end

# get an HTML representation of the form
# e.g., /form.html?pdf=http://help.adobe.com/en_US/Acrobat/9.0/Samples/interactiveform_enabled.pdf
get '/form' do
  pdf = PdfFiller.new
  liquid :form, :locals => { :pdf => params['pdf'], :fields => pdf.get_fields( params['pdf'] ) }, :layout => :bootstrap
end