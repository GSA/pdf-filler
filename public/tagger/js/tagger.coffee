jQuery ->

  tagger = {
    
    tags: []
    currentTag: {}
  
    #bind to DOM events
    init: -> 
      
      jQuery('.textLayer').live( 'click', tagger.click )
      jQuery('#addTag').live( 'click', tagger.addHandler )
      jQuery('#toolbarContainer .innerCenter').append('<button class="toolbarButton" id="tagSubmit">Submit</a>')
      jQuery('#tagSubmit').live( 'click', tagger.submit )

    #handle PDF Click       
    click: (e) ->
    
      #calculate the X.Y coordinates of the click
      #0,0 is the top left corner
      offset = $(this).offset()
      left = e.clientX - offset.left
      top = e.clientY - offset.top
    
      #convert to plane in which 0,0 is bottom left as PDF sees it
      bottom = $(this).height() - top
    
      tag = { x: left, y: bottom, page: $('#pageNumber').val() }
      tagger.popup( e.pageX, e.pageY, tag )

    #render popup
    popup: (x, y, tag ) ->
      tagger.reset()
      div = $('<div id="tagger"></div>').css( 'top', y ).css( 'left', x )
      div.html( Mustache.render( $('#taggerTemplate').html(), tag ) )
      tagger.currentTag = tag
      $('body').append( div )

    #callback to handle adding tag to data array
    addHandler: (e) ->
      e.preventDefault()
      tag = tagger.currentTag
      tag.name = $('#tagName').val()
      tag.type = $('#tagType').val()
      tagger.add( tag )
      tagger.reset()      
      false
    
    #reset tagger state to default
    reset: ->
      $('#tagger').remove()
      tagger.currentTag = {}
    
    #add tag to tag array
    add: (tag) ->
      tagger.tags.push( tag )
      
    submit: ->
      alert( "Here are your tags:\n\n" + JSON.stringify( tagger.tags ) )
    
  }
  
  #make accessible as global tagger object and init
  window.tagger = tagger
  tagger.init() 
