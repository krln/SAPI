require 'spec_helper'

describe TaxonConcept do
  describe :create do
    let(:parent){
      create(
        :genus,
        :taxon_name => create(:taxon_name, :scientific_name => 'Lolcatus')
      )
    }
    let!(:tc){
      create(
        :species,
        :parent_id => parent.id,
        :taxon_name => create(:taxon_name, :scientific_name => 'lolatus')
      )
    }
    let(:synonym){
      build(
        :species,
        :name_status => 'S',
        :author_year => 'Taxonomus 2013',
        :accepted_scientific_name => tc.full_name,
        :full_name => 'Lolcatus lolus'
      )
    }
    context "when new" do
      specify {
        lambda do
          synonym.save
        end.should change(TaxonConcept, :count).by(1)
      }
    end
    context "when duplicate" do
      let(:duplicate){
        synonym.dup
      }
      specify {
        lambda do
          synonym.save
          duplicate.save
        end.should change(TaxonConcept, :count).by(1)
      }
    end
    context "when duplicate but author name different" do
      let(:duplicate){
        res = synonym.dup
        res.author_year = 'Hemulen 2013'
        res
      }
      specify {
        lambda do
          synonym.save
          duplicate.save
        end.should change(TaxonConcept, :count).by(2)
      }
      specify {
        puts synonym.full_name
        synonym.save
        synonym.full_name.should == 'Lolcatus lolus'
      }
    end
  end
end