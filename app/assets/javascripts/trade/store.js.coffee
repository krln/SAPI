Trade.Store = DS.Store.extend({
  adapter: 'DS.RESTAdapter'
})

Trade.HashTransform = DS.Transform.extend
  serialize: (value) ->
    if (Em.typeOf(value) == 'hash')
      return value
    else
      return {}
  deserialize: (value) ->
    return value

Trade.ArrayTransform = DS.Transform.extend
  serialize: (value) ->
    if (Em.typeOf(value) == 'array')
      return value
    else
      return []
  deserialize: (value) ->
    return value

Trade.ApplicationAdapter = DS.RESTAdapter.extend
  namespace: 'trade'
  pathForType: (type) ->
    underscored = Ember.String.underscore(type)
    return Ember.String.pluralize(underscored)

# inject the store into all views/components
Trade.inject('view', 'store', 'store:main')
Trade.inject('component', 'store', 'store:main')

Trade.ApplicationSerializer = DS.ActiveModelSerializer.extend({})
