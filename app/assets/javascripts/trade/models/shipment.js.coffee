Trade.Shipment = DS.Model.extend
  appendix: DS.attr('string')
  reported_appendix: DS.attr('string')
  species_name: DS.attr('string')
  reported_species_name: DS.attr('string')
  term_code: DS.attr('string')
  quantity: DS.attr('string')
  unit_code: DS.attr('string')
  importer: DS.attr('string')
  exporter: DS.attr('string')
  reporter_type: DS.attr('string')
  country_of_origin: DS.attr('string')
  import_permit: DS.attr('string')
  export_permit: DS.attr('string')
  origin_permit: DS.attr('string')
  purpose_code: DS.attr('string')
  source_code: DS.attr('string')
  year: DS.attr('string')
  _destroyed: DS.attr('boolean')
