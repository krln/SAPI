Species.DownloadsForCmsListingsController = Ember.Controller.extend
  needs: ['geoEntities']
  designation: 'cms'
  appendices: ['I', 'II']
  selectedAppendices: []
  selectedGeoEntities: []
  selectedTaxonConcepts: []

  toParams: ( ->
    {
      data_type: 'Listings'
      filters: 
        selected_appendices: @get('selectedAppendices')
    }
  ).property('selectedAppendices.@each')

  downloadUrl: ( ->
    '/exports/download?' + $.param(@get('toParams'))
  ).property('toParams')