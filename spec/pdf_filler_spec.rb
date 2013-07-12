require 'spec_helper'

describe 'PdfFiller' do
  TEST_PDF = 'http://help.adobe.com/en_US/Acrobat/9.0/Samples/interactiveform_enabled.pdf'

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
      last_response.body.should contain(/PDF Filler/)
      last_response.body.should =~ /PDF Filler is a RESTful service \(API\) to aid in the completion of existing PDF-based forms/
    end
  end
  
  describe "POST /fill" do
    it "should return the PDF" do 
      post "/fill", :pdf => "./spec/sample.pdf"
      last_response.should be_ok
      last_response.headers['Content-Type'].should eq( 'application/pdf' )
    end
    
    it "should fill fields" do
      post "/fill", :pdf => "./spec/sample.pdf", :Name_Last => "_MYGOV_FILLABLE_", :"100,100,1" => "_MYGOV_NON_FILLABLE_"
      
      compressed = Tempfile.new( ['pdf', '.pdf'], nil , :encoding => 'ASCII-8BIT' )
      uncompressed = Tempfile.new( ['pdf', '.pdf'], nil , :encoding => 'ASCII-8BIT' )
      compressed << last_response.body
      
      pdftk = PdfForms.new(PATH_TO_PDFTK)
      pdftk.call_pdftk compressed.path, 'output', uncompressed.path, 'uncompress'
       
      file = File.open( uncompressed.path, 'rb' )
      contents = file.read
      contents.include?('_MYGOV_FILLABLE_').should be_true
      #contents.include?('_MYGOV_NON_FILLABLE_').should be_true      
    end
    
    context "when the PDF file has weird field names" do
      it "should still fill the fields properly" do
        post "/fill", :pdf => "./spec/ss-5.pdf", "topmostSubform%5B0%5D.Page5%5B0%5D.firstname%5B0%5D" => "_MYGOV_FILLABLE_"
        compressed = Tempfile.new(['pdf', '.pdf'], nil , :encoding => 'ASCII-8BIT')
        uncompressed = Tempfile.new( ['pdf', '.pdf'], nil , :encoding => 'ASCII-8BIT' )
        compressed << last_response.body
        pdftk = PdfForms.new(PATH_TO_PDFTK)
        pdftk.call_pdftk compressed.path, 'output', uncompressed.path, 'uncompress'
        file = File.open( uncompressed.path, 'rb' )
        contents = file.read
        contents.should =~ /MYGOV/
      end
    end
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
    it "should create a form for the pdf based on fields" do
      get "/form", :pdf => './spec/sample.pdf'
      last_response.should be_ok
      last_response.body.should =~ /PHD/
      last_response.body.should =~ /Emergency_Contact/
    end
  end
end
