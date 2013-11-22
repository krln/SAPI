Trade.Shipment = DS.Model.extend

  importerId: DS.attr('number')
  exporterId: DS.attr('number')
  termId: DS.attr('number')

  reporterType: DS.attr('string')

  appendix: DS.attr('string')
  taxonConceptId: DS.attr('number')
  taxonConcept: DS.belongsTo('taxonConcept')
  term: DS.belongsTo('term')
  quantity: DS.attr('string')
  unit: DS.belongsTo('unit')
  importer: DS.belongsTo('geoEntity', {
    inverse: 'importedShipments'
  })
  exporter: DS.belongsTo('geoEntity', {
    inverse: 'exportedShipments'
  })
  countryOfOrigin: DS.belongsTo('geoEntity', {
    inverse: 'countryOfOriginShipments'
  })
  importPermitNumber: DS.attr('string')
  exportPermitNumber: DS.attr('string')
  countryOfOriginPermitNumber: DS.attr('string')
  purpose: DS.belongsTo('purpose')
  source: DS.belongsTo('source')
  year: DS.attr('string')
  _destroyed: DS.attr('boolean')

  taxonConceptIdDidChange: ( ->
    if @get('taxonConceptId')
      @set('taxonConcept', @store.find('taxonConcept', @get('taxonConceptId')))
  ).observes('taxonConceptId')

Trade.ShipmentSerializer = DS.ActiveModelSerializer.extend
  attrs: {
    taxonConcept: { embedded: 'load' }
  }
