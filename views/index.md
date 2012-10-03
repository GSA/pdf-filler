PDF Form Filler
===============

RESTful service to fill both fillable and unfillable forms. Abstracts the form-filling logic of [pdftk](http://www.pdflabs.com/tools/pdftk-the-pdf-toolkit/) and [prawn-fillform](https://github.com/moessimple/prawn-fillform).

Usage
-----
PDF Filler works by accepting a key => value pair of field names and values. These fields can either be fillable PDF form fields, or can be an arbitrary x/y coordinate of a non-fillable field.

Getting Field Names
-------------------

Field names can be gotten locally using open-source PDF utility pdftk, or dynamically using the service.

**To get a list of all fields within a given PDF**

`/fields.html?pdf={URL to the PDF}`

**To get a JSON representation of all fields within a given PDF**

`/fields.json?pdf={URL to the PDF}`

Filling Out Forms
-----------------

To fill out a PDF, issue a `POST` request to `/fill`. POST data should be in the format of key => value where key reprents the field name and value represents the field value. Be sure to pass a key of "pdf" with the URL of the PDF to fill. The service will return the filled in PDF.

Generating HTML Forms
---------------------

**To get a generic HTML representation of any fillable PDF form**

`/form.html?pdf={URL To PDF}`

Non-Fillable PDFs
-----------------

Non-Fillable PDFs (e.g., scanned or other PDFs without structured forms) require passing X, Y coordinates, and (optionally) a page number. This data is passed using the following naming convention for the field: `x,y,page` (or simply `x,y`) where X and Y represent the pointer coordinates from the bottom left hand corner of the document. If no page is given, the first page will be assumed.

For example, to structure an HTML form, you may do so as follows:

```html
<form method="post" action ="/fill">
  
  <!-- A standard, fillable field, simply pass the field name -->
  <label>First Name: <input type="text" name="first_name" /><label>
  
  <!-- A non-fillable field for which we pass coordinates -->
  <label>Last Name: <input type="text" name="100,100,1" /><label>
  
  <input type="submit value="Submit" />
  
</form>
```

Hosting PDF Filler
------------------

You can freely use PDF Filler as a web service. But if you'd like to grab the source code and host it locally, it's actually pretty easy.

PDF Filler uses pdftk to handle the action form filling. pdftk can be [freely downloaded and installed](http://www.pdflabs.com/docs/install-pdftk/) on most systems. If installed at a location other than ``, be sure to update the configuration.

PDF Filler is written in Ruby and uses [Sinatra](http://www.sinatrarb.com/) to generate a RESTful API