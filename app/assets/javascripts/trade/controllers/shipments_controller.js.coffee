Trade.ShipmentsController = Ember.ArrayController.extend
  content: null

  tableController: Ember.computed ->
    controller = Ember.get('Trade.ShipmentsTable.TableController').create()
    controller.set 'shipments', @get('content')
    controller
  .property('content')

  pages: ( ->
    @get('content.meta.total')
  ).property('content.isLoaded')

  page: ( ->
    @get('content.meta.page') || 1
  ).property('content.isLoaded')

  showPrevPage: ( ->
    if @get('page') > 1 then return yes else return no
  ).property('page')

  showNextPage: ( ->
    if @get('page') < @get('pages') then return yes else return no
  ).property('page', 'pages')

  transitionToPage: (forward) ->
    page = if forward
      parseInt(@page) + 1
    else
      parseInt(@page) - 1
    @transitionToRoute('shipments', {page: page || 1})
