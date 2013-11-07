Trade.GeoEntity = DS.Model.extend
  name: DS.attr('string')
  isoCode2: DS.attr('string')

Trade.GeoEntityAdapter = Trade.ApplicationAdapter.extend(
  namespace: "api/v1"
)
