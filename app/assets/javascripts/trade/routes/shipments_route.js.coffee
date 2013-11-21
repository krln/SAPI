Trade.ShipmentsRoute = Ember.Route.extend

  beforeModel: ->
    @controllerFor('geoEntities').set('content', @store.find('geoEntity'))
    @controllerFor('terms').set('content', @store.find('term'))
    @controllerFor('units').set('content', @store.find('unit'))
    @controllerFor('sources').set('content', @store.find('source'))
    @controllerFor('purposes').set('content', @store.find('purpose'))

  model: (params, queryParams, transition) ->
    queryParams.page = 1 unless queryParams.page
    @store.find('shipment', queryParams)
