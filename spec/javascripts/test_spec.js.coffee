#= require spec_helper

describe 'Home - Integration', ->



    
  it 'welcomes you to the site', ->
    debugger
    visit('/').then ->
      debugger
      find('#main>h1>span').text().should.equal('species+')