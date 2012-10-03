require 'spec_helper'

describe 'PdfFiller' do
  def app
    Sinatra::Application
  end
  
  describe "GET /" do
    it "should return 200" do
      get '/'
      last_response.should be_ok
    end
    
    it "should show the README" do
      get '/'
      last_response.should =~ /PDF Form Filler/
      last_response.should =~ /RESTful service to fill both fillable and unfillable forms/
    end
  end
  
  describe "POST /fill" do
  end
  
  describe "GET /fields" do
    it "should output a page with all the fields" do
      get "/fields", :pdf => './spec/sample.pdf'
      last_response.should be_ok
      last_response.should =~ /PHD/
    end
  end
  
  describe "GET fields.json" do
    it "should output a valid JSON array representing the fields in the PDF" do
      get "/fields.json", :pdf => './spec/sample.pdf'
      last_response.should be_ok
      JSON.parse(last_response.body).is_a?(Array).should be_true
    end
  end
  
  describe "GET /form" do
  end
end