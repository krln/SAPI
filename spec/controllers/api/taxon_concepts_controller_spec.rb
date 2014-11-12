require 'spec_helper'
  
describe Api::V1::TaxonConceptsController do 
  context "GET index" do
  	it "logs search with Ahoy" do
  	  get :index, {
  	  	:taxonomy => 'cites_eu',
  	    :taxon_concept_query => 'Canis lupus',
  	    :geo_entity_scope => 'cites',
  	    :page => 1 }
  	  expect(response).to be_success    
      expect(Ahoy::Event.all.count).to eq(1)
      #expect(Ahoy::Visit.all.count).to eq(1)     
    end
  end
end      