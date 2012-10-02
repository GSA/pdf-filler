class Pdf_Filler
  
  require 'open-uri'
  require 'pdf_forms'
  require 'prawn'
  require 'prawn-fillform'
  
  #Grab remote PDF file and save to temporary location
  def download_pdf_to_temp_file( url )
  
    #Create temp file
    file = Tempfile.new( ['pdf', '.pdf'], nil , :encoding => 'ASCII-8BIT' )
    
    #read remote file into temporary file
    file << open(url).read
    
    #return temporary file
    file
    
  end

  #given a PDF an array of fields -> values
  # return a PDF with the given fields filled out
  def fill( url, data )
    
    #source PDF file to fill in
    source_pdf = download_pdf_to_temp_file( url )
    
    #pdftk object for filling in PDF
    pdftk = PdfForms.new( '/usr/local/bin/pdftk' )
    
    #PDF with fillable fields filled
    step_1_result = Tempfile.new( ['pdf', '.pdf'] )
    
    #final PDF with all fillable and unfillable fields filled
    filled_pdf = Tempfile.new( ['pdf', '.pdf'] )
    
    #Fill fillable fields via pdftk
    pdftk.fill_form source_pdf.path, step_1_result.path, data.find_all { !:at? }
    
    #Fill non-fillabel PDF fields via prawn
    Prawn::Document.generate filled_pdf.path, :template => step_1_result.path do |pdf|
    
      #set default font and size
      pdf.font("Helvetica", :size=> 10)
      
      #loop through each non-fillable field and
      # add to PDF at specified coordinates
      fields = data.find_all { :at? }
      fields.each do |field|
      
        #place the prawn pointer on the page with the field
        pdf.go_to_page field[:page]
        
        #write the contents of the field to the page
        pdf.draw_text field[:text], :at => field[:at]
        
      end #end fields loop
    
    end #end prawn loop
    
    #return resulting PDF  
    filled_pdf
    
  end
  
end