PDF Filler
===========

PDF Filler is a RESTful service (API) to aid in the completion of existing PDF-based forms and empowers web developers to use browser-based forms and modern web standards to facilitate the collection of information.

PDF Filler works with virtually any unencrypted PDF, supporting both fillable (e.g., PDFs with pre-defined entry fields) and non-fillable (e.g., scanned PDFs) forms. Simply pass it the URL to any publicly hosted PDF. PDF Filler can even automatically create the markup necessary to embed an HTML form in an existing webpage.

Features
-------

* RESTful service (API) to aid in the completion of PDF-based forms
* Submit form values via HTTP POST, receive the completed PDF as a download
* Works with both fillable and non-fillable (e.g., scanned) PDFs
* Dynamically generates HTML forms for any fillable PDF
* Provides developers with field name lookup service to facilitate the rapid development of client applications

Under the Hood
--------------

The project abstracts the form-filling logic of [pdftk](http://www.pdflabs.com/tools/pdftk-the-pdf-toolkit/) and [prawn](https://github.com/prawnpdf/prawn).

Usage
-----

PDF Filler works by accepting a key => value pair of field names and values. These fields can either be fillable PDF form fields, or can be an arbitrary x/y coordinate of a non-fillable field. For fillable PDFs the key should represent the field name. In non-fillable PDFs, the key should represent the field coordinates as described below (e.g., `100,100`). In both insstances, the field value should contain the user input for that given field.

Getting Field Names
-------------------

Field names can be discovered locally using open-source PDF utility pdftk, or dynamically using the service.

**To get a list of all fields within a given PDF**

`/fields?pdf={URL to the PDF}`

**To get a JSON representation of all fields within a given PDF**

`/fields.json?pdf={URL to the PDF}`

Filling Out Forms
-----------------

To fill out a PDF, issue a `POST` request to `/fill`. POST data should be in the format of key => value where key represents the field name and value represents the field value. Be sure to pass a key of "pdf" with the URL of the PDF to fill. The service will return the filled in PDF as a download.

*Note: Due to the way HTML handles forms, certain special characters such as square brackets will not properly POST to the service. If the PDF field contains reserved characters, simply [urlencode](http://en.wikipedia.org/wiki/Percent-encoding) the field name prior to POSTing.*

Generating HTML Forms
---------------------

**To get a generic HTML representation of any fillable PDF form**

`/form?pdf={URL To PDF}`

Non-Fillable PDFs
-----------------

Non-Fillable PDFs (e.g., scanned or other PDFs without structured forms) require passing X, Y coordinates, and (optionally) a page number. This data is passed using the following naming convention for the field: `x,y,page` (or simply `x,y`) where X and Y represent the pointer coordinates from the bottom left hand corner of the document. If no page is given, the first page will be assumed.

Structuring the HTML Form
-------------------------

Data can be submitted programmatically (e.g. via an API) or as a standard web-based form. For example, to structure an HTML form, you may do so as follows:

```html

    <form method="post" action ="/fill">

      <!-- A standard, fillable field, simply pass the field name -->
      <label>First Name: <input type="text" name="first_name" /><label>

      <!-- A non-fillable field for which we pass coordinates -->
      <label>Last Name: <input type="text" name="100,100,1" /><label>

      <input type="submit" value="Submit" />

    </form>

```

Requirements
------------
* Latest stable version of Ruby (+ the Bundler gem)
* PDFtk

OR

* Docker

Setting up
----------
_(If running in Docker, skip to 'Running' section)_
1. Install the latest version of Ruby if not already installed (`$ \curl -L https://get.rvm.io | bash -s stable --ruby`)
2. Install [PDFtk](http://www.pdflabs.com/docs/install-pdftk/)
3. Install bundler if not already installed (`gem install bundler`)
4. Install git if not already installed (or simply download the repository and unzip in the following step)
5. Clone the git repository (`git clone git@github.com:GSA-OCSIT/pdf-filler.git` and `cd` into the target directory (most likely `pdf-filler`)
6. `bundle install`

Running
-------
#### Local
To run, simply run the command `ruby app.rb` from the project's directory.

#### Docker
```
$ docker-compose build
$ docker-compose up
```

For both methods the service will be exposed on port `4567` by default.

You can freely use PDF Filler as a web service. But if you'd like to grab the source code and host it locally, it's actually pretty easy.

PDF Filler uses pdftk to handle the action form filling. pdftk can be [freely downloaded and installed](http://www.pdflabs.com/docs/install-pdftk/) on most systems. If installed at a location other than `/usr/local/bin/pdftk`, be sure to update the configuration by setting the environmental variable `PATH_TO_PDFTK` to the proper path.

PDF Filler is written in Ruby and uses [Sinatra](http://www.sinatrarb.com/) to generate a RESTful API

Deploying
-------

PDF Filler is simple to deploy as a backend service on your server.  Follow the instructions here: http://www.kalzumeus.com/2010/01/15/deploying-sinatra-on-ubuntu-in-which-i-employ-a-secretary/ as an example of how to deploy and set up the app as a backend service on your machine.  There is a file called daemon.rb that is part of the app for this purpose.

Hosting
------

The app is designed to be hosted on hosting services like heroku. If using Heroku, be sure to select the "Bamboo" build (which comes compiled with pdftk) and set an environment config for `PATH_TO_PDFTK` to `/usr/bin/pdftk`.

Examples
--------

* [Fields](http://labs.data.gov/pdf-filler/fields?pdf=http://help.adobe.com/en_US/Acrobat/9.0/Samples/interactiveform_enabled.pdf)
* [Form](http://labs.data.gov/pdf-filler/form?pdf=http://help.adobe.com/en_US/Acrobat/9.0/Samples/interactiveform_enabled.pdf)

Contributing
------------

Anyone is encouraged to contribute to the project by [forking](https://help.github.com/articles/fork-a-repo) and submitting a pull request. (If you are new to GitHub, you might start with a [basic tutorial](https://help.github.com/articles/set-up-git).)

By contributing to this project, you grant a world-wide, royalty-free, perpetual, irrevocable, non-exclusive, transferable license to all users under the terms of the [MIT](http://opensource.org/licenses/mit-license.php) License.

License
-------

This project constitutes a United States Government Work under 17 USC 105 and is distributed under the terms of the [MIT License](http://opensource.org/licenses/mit-license.php).
