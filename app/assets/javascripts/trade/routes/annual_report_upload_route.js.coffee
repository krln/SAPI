Trade.AnnualReportUploadRoute = Ember.Route.extend
  beforeModel: ->
    @controllerFor('geoEntities').set('content', @store.find('geoEntity'))

  model: (params) ->
    @store.find('annualReportUpload', params.annual_report_upload_id)

  afterModel: (aru, transition) ->
    if (aru.get('sandboxShipments.length') == 0)
      aru.reload()
