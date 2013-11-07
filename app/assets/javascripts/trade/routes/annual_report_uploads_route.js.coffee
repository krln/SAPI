Trade.AnnualReportUploadsRoute = Ember.Route.extend
  beforeModel: ->
    @controllerFor('geoEntities').set('content', @store.find('geoEntity'))

  model: () ->
    @store.find('annualReportUpload', {is_done: 0})
