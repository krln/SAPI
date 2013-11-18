Trade.QueryParams = Ember.Mixin.create({

  selectedQueryParamNames: [
    {
      name: "selectedTaxonConcepts"
      param: 'taxon_concepts_ids[]'
    },
    {
      name: "selectedAppendices"
      param: 'appendices[]'
    },
    {
      name: "selectedTimeStart"
      param: 'time_range_start'
    },
    {
      name: "selectedTimeEnd"
      param: 'time_range_end'
    },
    {
      name: "selectedTerms"
      param: 'terms_ids[]'
    },
    {
      name: "selectedUnits"
      param: 'units_ids[]'
    },
    {
      name: "selectedPurposes"
      param: 'purposes_ids[]'
    },
    {
      name: "selectedSources"
      param: 'sources_ids[]'
    },
    {
      name: "selectedImporters"
      param: 'importers_ids[]'
    },
    {
      name: "selectedExporters"
      param: 'exporters_ids[]'
    },
    {
      name: "selectedCountriesOfOrigin"
      param: 'countries_of_origin_ids[]'
    },
    {
      name: "selectedReporterTypeValues"
      param: 'reporter_type'
    },
    {
      name: "selectedPermits"
      param: 'permits_ids[]'
    },
    {
      name: "selectedQuantity"
      param: 'quantity'
    }
  ]
});