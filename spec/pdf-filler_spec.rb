require 'spec_helper'

describe 'Pdf_Filler' do

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
end