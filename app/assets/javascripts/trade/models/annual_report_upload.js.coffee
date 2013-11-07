Trade.AnnualReportUpload = DS.Model.extend
  numberOfRows: DS.attr('number')
  pointOfView: DS.attr('string')
  tradingCountry: DS.belongsTo('geoEntity', {key: 'trading_country_id'})
  hasPrimaryErrors: DS.attr('boolean')
  createdAt: DS.attr('date')
  updatedAt: DS.attr('date')
  # TODO created_by
  # TODO updated_by
  sandboxShipments: DS.hasMany('sandboxShipment')
  validationErrors: DS.hasMany('validationError')

  summary: (->
  	@get('numberOfRows') + ' shipments reported by ' +
  	@get('tradingCountry.name') + ' (' + @get('pointOfView') + ')' +
  	' uploaded on ' + @get('createdAt') + ' by TODO'
  ).property('numberOfRows', 'tradingCountry.name')

Trade.AnnualReportUploadSerializer = DS.ActiveModelSerializer.extend
  attrs: {
    sandboxShipments: { embedded: 'always' }
    validationErrors: { embedded: 'load' }
  }