#= require sinon
#= require spec_helper

describe 'Home - Integration', ->

  server = null

  beforeEach (done) ->
    
    # Fake XHR
    server = sinon.fakeServer.create()
    server.autoRespond = true
    Ember.run ->
      
      # Advance Species readiness, which was deferred above.
      #http://localhost:3500/api/v1/geo_entities?geo_entity_types_set=3
      server.respondWith "GET", "/api/v1/geo_entities?geo_entity_types_set=3", [
        200
        {
          "Content-Type": "Specieslication/json"
        }
        JSON.stringify(
          geo_entities: []
          meta: 
            total: 256
        )
      ]
      Species.advanceReadiness()
      
      # Setup is complete when the Species readiness promise resolves
      Species.then ->
        done()
        return
  
      return
  
    return
  
  afterEach ->
    server.respondWith "GET", "/api/v1/geo_entities?geo_entity_types_set=3", [
      200
      {
        "Content-Type": "Specieslication/json"
      }
      JSON.stringify(
        geo_entities: []
        meta: 
          total: 256
      )
    ]
    Species.reset()
    
    # Restore XHR
    server.restore()
    return

    
  it 'welcomes you to the site', ->
    visit('/').then ->
      find('#main>h1>span').text().should.equal('species+')