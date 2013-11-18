require 'spec_helper'
describe Trade::Filter do
  describe :results do
    before(:each) do
      @taxon_concept1 = create_cites_eu_species(
        :taxon_name => create(:taxon_name, :scientific_name => 'abstractus'),
        :parent => create_cites_eu_genus(:taxon_name => create(:taxon_name, :scientific_name => 'Foobarus'))
      )
      @taxon_concept2 = create_cites_eu_species(
        :taxon_name => create(:taxon_name, :scientific_name => 'totalus'),
        :parent => create_cites_eu_genus(:taxon_name => create(:taxon_name, :scientific_name => 'Nullificus'))
      )

      @argentina = create(:geo_entity,
                          :geo_entity_type => create(:geo_entity_type, :name => 'COUNTRY'),
                          :name => 'Argentina',
                          :iso_code2 => 'AR'
                         )

      @portugal = create(:geo_entity,
                         :geo_entity_type => create(:geo_entity_type, :name => 'COUNTRY'),
                         :name => 'Portugal',
                         :iso_code2 => 'PT'
                        )

      @term = create(:term, :code => 'CAV')
      @unit = create(:unit, :code => 'KIL')
      @purpose = create(:purpose, :code => 'T')
      @source = create(:source, :code => 'W')
      @import_permit = create(:permit, :number => 'AAA')
      @export_permit1 = create(:permit, :number => 'BBB')
      @export_permit2 = create(:permit, :number => 'CCC')
      @shipment1 = create(
        :shipment,
        :taxon_concept => @taxon_concept1,
        :appendix => 'I',
        :purpose => @purpose,
        :source => @source,
        :term => @term,
        :unit => @unit,
        :importer => @argentina,
        :exporter => @portugal,
        :country_of_origin => @argentina,
        :year => 2012,
        :reported_by_exporter => true,
        :import_permit => @import_permit,
        :export_permits=> [@export_permit1, @export_permit2],
        :quantity => 20
      )
      @shipment2 = create(
        :shipment,
        :taxon_concept => @taxon_concept2,
        :appendix => 'II',
        :purpose => @purpose,
        :source => @source,
        :term => @term,
        :unit => @unit,
        :importer => @portugal,
        :exporter => @argentina,
        :country_of_origin => @portugal,
        :year => 2013,
        :reported_by_exporter => false

      )
    end
    context "when searching by taxon concepts ids" do
      subject { Trade::Filter.new({:taxon_concepts_ids => [@taxon_concept1.id]}).results }
      specify { subject.should include(@shipment1) }
      specify { subject.length.should == 1 }
    end
    context "when searching by appendices" do
      subject { Trade::Filter.new({:appendices => ['I']}).results }
      specify { subject.should include(@shipment1) }
      specify { subject.length.should == 1 }
    end

    context "when searching for terms_ids" do
      subject { Trade::Filter.new({:terms_ids => [@term.id]}).results }
      specify { subject.should include(@shipment1) }
      specify { subject.length.should == 2 }
    end


    context "when searching for units_ids" do
      subject { Trade::Filter.new({:units_ids => [@unit.id]}).results }
      specify { subject.should include(@shipment1) }
      specify { subject.length.should == 2 }
    end


    context "when searching for purposes_ids" do
      subject { Trade::Filter.new({:purposes_ids => [@purpose.id]}).results }
      specify { subject.should include(@shipment1) }
      specify { subject.length.should == 2 }
    end


    context "when searching for sources_ids" do
      subject { Trade::Filter.new({:sources_ids => [@source.id]}).results }
      specify { subject.should include(@shipment1) }
      specify { subject.length.should == 2 }
    end


    context "when searching for importers_ids" do
      subject { Trade::Filter.new({:importers_ids => [@argentina.id]}).results }
      specify { subject.should include(@shipment1) }
      specify { subject.length.should == 1 }
    end

    context "when searching for exporters_ids" do
      subject { Trade::Filter.new({:exporters_ids => [@argentina.id]}).results }
      specify { subject.should include(@shipment2) }
      specify { subject.length.should == 1 }
    end

    context "when searching for countries_of_origin_ids" do
      subject { Trade::Filter.new({:countries_of_origin_ids => [@argentina.id]}).results }
      specify { subject.should include(@shipment1) }
      specify { subject.length.should == 1 }
    end

    context "when searching by year" do
      context "when time range specified" do
        subject { Trade::Filter.new({:time_range_start => 2013, :time_range_end => 2015}).results }
        specify { subject.should include(@shipment2) }
        specify { subject.length.should == 1 }
      end
      context "when time range specified incorrectly" do
        subject { Trade::Filter.new({:time_range_start => 2013, :time_range_end => 2012}).results }
        specify { subject.length.should == 0 }
      end
      context "when time range start specified" do
        subject { Trade::Filter.new({:time_range_start => 2012}).results }
        specify { subject.should include(@shipment1) }
        specify { subject.length.should == 2 }
      end
      context "when time range end specified" do
        subject { Trade::Filter.new({:time_range_end => 2012}).results }
        specify { subject.should include(@shipment1) }
        specify { subject.length.should == 1 }
      end
    end

    context "when searching by reporter_type" do
      context "when reporter type is not I or E" do
        subject { Trade::Filter.new({:reporter_type => 'K'}).results }
        specify { subject.length.should == 2 }
      end

      context "when reporter type is I" do
        subject { Trade::Filter.new({:reporter_type => 'I'}).results }
        specify { subject.should include(@shipment2) }
        specify { subject.length.should == 1 }
      end

      context "when reporter type is E" do
        subject { Trade::Filter.new({:reporter_type => 'E'}).results }
        specify { subject.should include(@shipment1) }
        specify { subject.length.should == 1 }
      end
    end


    context "when searching by permit" do
      subject { Trade::Filter.new({:permits_ids => [@export_permit1.id]}).results }
      specify { subject.should include(@shipment1) }
      specify { subject.length.should == 1 }
    end

    context "when searching by quantity" do
      subject { Trade::Filter.new({:quantity => 20}).results }
      specify { subject.should include(@shipment1) }
      specify { subject.length.should == 1 }
    end
  end

  describe :total_cnt do
    before(:each) do
      @shipment1 = create(:shipment,
                          :appendix => 'I',
                          :quantity => 20)
      @shipment1 = create(:shipment,
                          :appendix => 'II',
                          :quantity => 20)
    end

    context "when noone matches" do
      subject { Trade::Filter.new({:appendices => ['III']}) }
      specify { subject.total_cnt.should == 0 }
    end

    context "when one matches" do
      subject { Trade::Filter.new({:appendices => ['I']}) }
      specify { subject.total_cnt.should == 1 }
    end

    context "when two match" do
      subject { Trade::Filter.new({:quantity => 20}) }
      specify { subject.total_cnt.should == 2 }
    end


  end
end