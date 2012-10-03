require 'spec_helper'

describe 'PdfFiller' do

  TEST_PDF = 'http://help.adobe.com/en_US/Acrobat/9.0/Samples/interactiveform_enabled.pdf'
  TEST_DATA = [ "Name_Last" => "_MYGOV_FILLABLE_", "100,100,1" => "_MYGOV_NON_FILLABLE_" ]

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
    
    it "should return the PDF" do 
      post "/fill?pdf=" + TEST_PDF
      last_response.should be_ok
      last_response.headers['Content-Type'].should eq( 'application/pdf' )

    end
    
    it "should fill fields" do
      
      post "/fill?pdf=" + TEST_PDF, :data => TEST_DATA
      
      file = Tempfile.new( ['pdf', '.pdf'], nil , :encoding => 'ASCII-8BIT' )
      file << last_response.body
      
      pdftk = PdfForms.new( '/usr/local/bin/pdftk' )
      pdftk.call_pdftk file.path, 'output', file.path, 'uncompress'
       
      file = File.open( file, 'rb' )
      contents = file.read
      #contents.should =~ /_MYGOV_FILLABLE_/
      #contents.should =~ /_MYGOV_NON_FILLABLE_/

    end

  end
  
end