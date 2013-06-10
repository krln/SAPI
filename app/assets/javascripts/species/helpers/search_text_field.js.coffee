#
# * An extended TextField for use in scientific name search.
# *
# * Handles text change events and creates an autocomplete box for the text.
# 

# Possible typehead alternatives:
# https://github.com/tcrosen/twitter-bootstrap-typeahead/tree/2.0
# https://github.com/twitter/typeahead.js

Species.SearchTextField = Ember.TextField.extend(

  value: ""
  attributeBindings: ["autocomplete"]

  keyUp: (event) ->
    searchFormController = @get "controller"
    searchFormController.set "scientific_name", $(event.target).val()
    
  click: (event) ->
    self = @
    if $(".typeahead").length <= 0
      $("#scientific_name").typeahead
        minLength: 3
        source: (query, process) ->
          $.get "http://0.0.0.0:3000/api/v1/taxon_concepts/autocomplete",
            scientific_name: query
            rank_name: query
            full_name: query 
            limit: 10
          , (data) ->
            #console.log JSON.stringify(data.taxon_concepts)
            labels = self.parser data.taxon_concepts
            #console.log labels
            #$.each(data.taxon_concepts, (i, item) =>
            #  console.log  'OOOO', item.full_name
            #  label = item.full_name
            #  labels.push(label)
            #)
            process(labels)
        sorter: self.sorter
        matcher: self.matcher
        updater: self.updater
        highlighter: self.highlighter


    @$().val ""  if @$().val() is @get("placeholder")
    @$().attr "placeholder", ""

  focusOut: (event) ->
    @$().val @get("placeholder")  if @$().val().length is 0  if $.browser.msie
    @$().attr "placeholder", @get("placeholder")

  updater: (item) ->
    #console.log "updater", item
    # Remove synonyms when an item is selected
    item.replace /(.*)( \(\=.*\))/, "$1"

  highlighter: (item) ->
    query = @query.replace(/[\-\[\]{}()*+?.,\\\^$|#\s]/g, "\\$&")
    transform = ($1, match) ->
      "<span style=\"text-decoration:underline\">" + match + "</span>"

    item.replace(new RegExp("^(" + query + ")", "i"), transform).replace new RegExp("=(" + query + ")", "ig"), transform

  matcher: (item) ->
    #console.log item, @query
    true

  sorter: (items) ->
    items

  parser: (data) ->
    results = []
    # Extract the names of each result row for use by typeahead.js
    _.each data, (el, idx) ->
      unless "_#{el.rank_name}" in results
        results.push "_#{el.rank_name}"
      entry = el.full_name
      entry += " (=" + el.matching_names.join(", ") + ")"  if el.matching_names.length > 0
      results.push entry
    results

  didInsertElement: ->
    @$().val @$().attr("placeholder")  if $.browser.msie


)