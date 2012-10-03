class Pdf_Filler
  
  require 'open-uri'
  require 'pdf_forms'
  require 'prawn'
  require 'prawn-fillform'
  require 'json'
  
  #path to the pdftk binary
  #if you don't have it, you can get it here:
  #http://www.pdflabs.com/docs/install-pdftk/
  PATH_TO_PDFTK = '/usr/local/bin/pdftk'
  
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
  
    #regular expression to determine if fillable or non-fillable field
    #validates 1,2 and 1,2,3
    key_regex = /^(?<x>[0-9]+),(?<y>[0-9]+)(,(?<page>[0-9]+))?$/
    
    #source PDF file to fill in
    source_pdf = download_pdf_to_temp_file( url )
    
    #pdftk object for filling in PDF
    pdftk = PdfForms.new( PATH_TO_PDFTK )
    
    #PDF with fillable fields filled
    step_1_result = Tempfile.new( ['pdf', '.pdf'] )
    
    #final PDF with all fillable and unfillable fields filled
    filled_pdf = Tempfile.new( ['pdf', '.pdf'] )
    
    #Fill fillable fields via pdftk
    #filter fillable fields by key regex
    pdftk.fill_form source_pdf.path, step_1_result.path, data.find_all { |key, value| !key[ key_regex] }
    
    #Fill non-fillabel PDF fields via prawn
    Prawn::Document.generate filled_pdf.path, :template => step_1_result.path do |pdf|
    
      #set default font and size
      pdf.font("Helvetica", :size=> 10)
      
      #loop through each non-fillable field and
      # add to PDF at specified coordinates
      fields = data.find_all { |key, value| key[ key_regex] }
      fields.each do |key, value|
      
        #break the field key down into its reprentative parts
        # this will give us a hash with x, y, and (optionally) page
        at = key.match( key_regex )
        
        #place the prawn pointer on the page with the field
        #if we're not given a page, assume page one
        pdf.go_to_page at[:page].to_i || 1
        
        #write the contents of the field to the page
        pdf.draw_text value, :at => [ at[ :x ].to_i, at[:y].to_i ]
        
      end #end fields loop
    
    end #end prawn loop

    #return resulting PDF  
    filled_pdf
    
  end
  
  #return a hash of all fields in a given PDF
  def get_fields( url ) 
  
    #grab external PDF and store locally
    source_pdf = download_pdf_to_temp_file( url )
    
    #init new pdftk wrapper
    pdftk = PdfForms.new( PATH_TO_PDFTK )
    
    #return list of all fields
    pdftk.get_field_names( source_pdf )

  end
  
end