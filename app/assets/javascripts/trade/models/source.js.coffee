Trade.Source = DS.Model.extend
  code: DS.attr('string')
  shipments: DS.hasMany('Trade.Shipment')