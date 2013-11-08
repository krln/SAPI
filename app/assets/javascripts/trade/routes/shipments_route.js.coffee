Trade.ShipmentsRoute = Ember.Route.extend
  model: (params, queryParams, transition) ->
    return unless queryParams.page
    @store.find('shipment', queryParams)
