Trade.ValidationRulesRoute = Ember.Route.extend
  model: () ->
    @store.find('validationRule')
