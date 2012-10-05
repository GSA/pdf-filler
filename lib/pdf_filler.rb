require 'open-uri'
require 'pdf_forms'
require 'prawn'
require 'json'

class PdfFiller

  #path to the pdftk binary
  #http://www.pdflabs.com/docs/install-pdftk/
  PATH_TO_PDFTK = ENV['PATH_TO_PDFTK'] || '/usr/local/bin/pdftk'

  # regular expression to determine if fillable or non-fillable field
  # validates 1,2 and 1,2,3
  KEY_REGEX = /^(?<x>[0-9]+),(?<y>[0-9]+)(,(?<page>[0-9]+))?$/

  def initialize
    @pdftk = PdfForms.new(PATH_TO_PDFTK)
  end
  
  # Given a PDF an array of fields -> values
  # return a PDF with the given fields filled out
  def fill( url, data )
    
    source_pdf = open(url)
    step_1_result = Tempfile.new( ['pdf', '.pdf'] )
    filled_pdf = Tempfile.new( ['pdf', '.pdf'] )
    
    #Fill fillable fields (step 1)
    @pdftk.fill_form source_pdf.path, step_1_result.path, data.find_all{ |key, value| !key[KEY_REGEX] }
    
    #Fill non-fillable fields (returning filled pdf)
    Prawn::Document.generate filled_pdf.path, :template => step_1_result.path do |pdf|
      pdf.font("Helvetica", :size=> 10)
      fields = data.find_all { |key, value| key[KEY_REGEX] }
      fields.each do |key, value|
        at = key.match(KEY_REGEX)
        pdf.go_to_page at[:page].to_i || 1
        pdf.draw_text value, :at => [ at[ :x ].to_i, at[:y].to_i ]
      end
    end
    filled_pdf
  end
  
  # Return a hash of all fields in a given PDF
  def get_fields(url)
    @pdftk.get_field_names(open(url).path)
  end
end