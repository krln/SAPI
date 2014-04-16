#= require sinon
#= require species
#= require ember-mocha-adapter

Ember.Test.adapter = Ember.Test.MochaAdapter.create()
Species.setupForTesting()
Species.injectTestHelpers()


mocha.globals(['Ember', 'DS', 'Species', 'MD5'])
mocha.timeout(500)
chai.Assertion.includeStack = true
Konacha.reset = Ember.K

$.fx.off = true

afterEach ->
  Species.reset()

#Species.setup()
Species.advanceReadiness()