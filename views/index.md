PDF Form Filler
===============

RESTful service to fill both fillable and unfillable forms

Usage
-----
PDF Filler works by accepting a key => value pair of field names and values. These fields can either be fillable PDF form fields, or can be an arbitrary x/y coordinate of a non-fillable field.

Getting Field Names
-------------------

Field names can be gotten locally using open-source PDF utility pdftk, or dynamically using this service.

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