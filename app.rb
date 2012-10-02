# app.rb
require 'rubygems'
require 'sinatra'
require 'liquid'
require './pdf-filler.rb'

set :public_folder, File.dirname(__FILE__) + '/static'

#return a filled PDF as a result of post data
post '/fill' do
  pdf = Pdf_Filler.new
  send_file pdf.fill( params['pdf'], params ).path
end

#return JSON list of field names
#e.g., /fields.json?pdf=http://help.adobe.com/en_US/Acrobat/9.0/Samples/interactiveform_enabled.pdf
get '/fields.json' do
  pdf = Pdf_Filler.new
  pdf.get_fields( params['pdf'] ).to_json
end

#e.g., /fields.json?pdf=http://help.adobe.com/en_US/Acrobat/9.0/Samples/interactiveform_enabled.pdf
get '/fields.html' do
  pdf = Pdf_Filler.new
  liquid :fields, :locals => { :pdf => params['pdf'], :fields => pdf.get_fields( params['pdf'] ) }
end

#e.g., /fields.json?pdf=http://help.adobe.com/en_US/Acrobat/9.0/Samples/interactiveform_enabled.pdf
get '/form.html' do
  pdf = Pdf_Filler.new
  liquid :form, :locals => { :pdf => params['pdf'], :fields => pdf.get_fields( params['pdf'] ) }
end