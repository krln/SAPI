Trade.GeoEntity = DS.Model.extend
  name: DS.attr('string')
  isoCode2: DS.attr('string')

  importedShipments: DS.hasMany('shipment', {
    inverse: 'importer'
  })
  exportedShipments: DS.hasMany('shipment', {
    inverse: 'exporter'
  })
  countryOfOriginShipments: DS.hasMany('shipment', {
    inverse: 'countryOfOrigin'
  })

Trade.GeoEntityAdapter = Trade.ApplicationAdapter.extend(
  namespace: "api/v1"
)
