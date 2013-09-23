shared_context :sapi do

  let(:cites_eu){
    create(:taxonomy, :name => Taxonomy::CITES_EU)
  }

  let(:cms){
    create(:taxonomy, :name => Taxonomy::CMS)
  }

  let(:cites){
    d = Designation.find_by_taxonomy_id_and_name(cites_eu.id, Designation::CITES)
    unless d
      d = create(:designation, :name => Designation::CITES, :taxonomy => cites_eu)
      %w(ADDITION DELETION RESERVATION RESERVATION_WITHDRAWAL EXCEPTION).each do |ch|
        ch_type = ChangeType.find_by_designation_id_and_name(d.id, ch)
        unless ch_type
          create(:change_type, :name => ch, :designation => d)
        end
        %w(I II III).each do |app|
          unless SpeciesListing.find_by_designation_id_and_abbreviation(d.id, app)
            create(
              :species_listing, :name => "Appendix #{app}", :abbreviation => app,
              :designation => d
            )
          end
        end
      end
    end
    d  
  }

  let(:eu){
    d = Designation.find_by_taxonomy_id_and_name(cites_eu.id, Designation::EU)
    unless d
      d = create(:designation, :name => Designation::EU, :taxonomy => cites_eu)
      %w(ADDITION DELETION RESERVATION RESERVATION_WITHDRAWAL EXCEPTION).each do |ch| 
        unless ChangeType.find_by_designation_id_and_name(d.id, ch)
          create(:change_type, :name => ch, :designation => d)
        end
        %w(A B C D).each do |app| 
          unless SpeciesListing.find_by_designation_id_and_abbreviation(d.id, app)
            create(
              :species_listing, :name => "Annex #{app}", :abbreviation => app,
              :designation => d
            )
          end
        end
      end
    end
    d
  }

  let(:cms_designation){
    d = Designation.find_by_taxonomy_id_and_name(cms.id, Designation::CMS)
    unless d
      d = create(:designation, :name => Designation::CMS, :taxonomy => cms)
      %w(ADDITION DELETION EXCEPTION).each do |ch|
        unless ChangeType.find_by_designation_id_and_name(d.id, ch)
          create(:change_type, :name => ch, :designation => d)
        end
        %w(I II).each do |app|
          unless SpeciesListing.find_by_designation_id_and_abbreviation(d.id, app)
            create(
              :species_listing, :name => "Appendix #{app}", :abbreviation => app,
              :designation => d
            )
          end
        end
      end
    end
    d
  }

  %w(ADDITION DELETION RESERVATION RESERVATION_WITHDRAWAL EXCEPTION).each do |ch|

    define_method "cites_#{ch.downcase}" do
      ChangeType.find_by_designation_id_and_name(cites.id, ch)
    end

    define_method "eu_#{ch.downcase}" do
      ChangeType.find_by_designation_id_and_name(eu.id, ch)
    end

    %w(I II III).each do |app|
      define_method "cites_#{app}" do
        SpeciesListing.find_by_designation_id_and_abbreviation(cites.id, app)
      end
      define_method "create_cites_#{app}_#{ch.downcase}" do |options = {}|
        create(
          :listing_change,
          options.merge({
            :change_type => send(:"cites_#{ch.downcase}"),
            :species_listing => send(:"cites_#{app}")
          })
        )
      end
    end
    %w(A B C D).each do |app|
      define_method "eu_#{app}" do
        SpeciesListing.find_by_designation_id_and_abbreviation(eu.id, app)
      end
      define_method "create_eu_#{app}_#{ch.downcase}" do |options = {}|
        create(
          :listing_change,
          options.merge({
            :change_type => send(:"eu_#{ch.downcase}"),
            :species_listing => send(:"eu_#{app}")
          })
        )
      end
    end
  end

  %w(ADDITION DELETION EXCEPTION).each do |ch|

    define_method "cms_#{ch.downcase}" do
      ChangeType.find_by_designation_id_and_name(cms_designation.id, ch)
    end

    %w(I II).each do |app|
      define_method "cms_#{app}" do
        SpeciesListing.find_by_designation_id_and_abbreviation(cms_designation.id, app)
      end
      define_method "create_cms_#{app}_#{ch.downcase}" do |options = {}|
        create(
          :listing_change,
          options.merge({
            :change_type => send(:"cms_#{ch.downcase}"),
            :species_listing => send(:"cms_#{app}")
          })
        )
      end
    end
  end

  let(:kingdom_rank){
    create(
      :rank,
      :name => Rank::KINGDOM, :taxonomic_position => '1', :fixed_order => true
    )
  }
  let(:phylum_rank){
    create(
      :rank,
      :name => Rank::PHYLUM, :taxonomic_position => '2', :fixed_order => true
    )
  }
  let(:class_rank){
    create(
      :rank,
      :name => Rank::CLASS, :taxonomic_position => '3', :fixed_order => true
    )
  }
  let(:order_rank){
    create(
      :rank,
      :name => Rank::ORDER, :taxonomic_position => '4', :fixed_order => false
    )
  }
  let(:family_rank){
    create(
      :rank,
      :name => Rank::FAMILY, :taxonomic_position => '5', :fixed_order => false
    )
  }
  let(:subfamily_rank){
    create(
      :rank,
      :name => Rank::SUBFAMILY, :taxonomic_position => '5.1', :fixed_order => false
    )
  }
  let(:genus_rank){
    create(
      :rank,
      :name => Rank::GENUS, :taxonomic_position => '6', :fixed_order => false
    )
  }
  let(:species_rank){
    create(
      :rank,
      :name => Rank::SPECIES, :taxonomic_position => '7', :fixed_order => false
    )
  }
  let(:subspecies_rank){
    create(
      :rank,
      :name => Rank::SUBSPECIES, :taxonomic_position => '7.1', :fixed_order => false
    )
  }
  let(:variety){
    create(
      :rank,
      :name => Rank::VARIETY, :taxonomic_position => '7.2', :fixed_order => false
    )
  }
  let(:cites_eu_animalia){
    create_cites_eu_kingdom(
      :taxonomic_position => '1',
      :taxon_name => create(:taxon_name, :scientific_name => 'Animalia')
    )
  }
  let(:cms_animalia){
    create_cms_kingdom(
      :taxonomic_position => '1',
      :taxon_name => create(:taxon_name, :scientific_name => 'Animalia')
    )
  }
  let(:cites_eu_chordata){
    create_cites_eu_phylum(
      :taxonomic_position => '1.1',
      :taxon_name => create(:taxon_name, :scientific_name => 'Chordata'),
      :parent => cites_eu_animalia
    )
  }
  let(:cms_chordata){
    create_cms_phylum(
      :taxonomic_position => '1.1',
      :taxon_name => create(:taxon_name, :scientific_name => 'Chordata'),
      :parent => cms_animalia
    )
  }
  let(:cites_eu_mammalia){
    create_cites_eu_class(
      :taxonomic_position => '1.1.1',
      :taxon_name => create(:taxon_name, :scientific_name => 'Mammalia'),
      :parent => cites_eu_chordata
    )
  }
  let(:cms_mammalia){
    create_cms_class(
      :taxonomic_position => '1.1.1',
      :taxon_name => create(:taxon_name, :scientific_name => 'Mammalia'),
      :parent => cms_chordata
    )
  }
  let(:cites_eu_aves){
    create_cites_eu_class(
      :taxonomic_position => '1.1.2',
      :taxon_name => create(:taxon_name, :scientific_name => 'Aves'),
      :parent => cites_eu_chordata
    )
  }
  let(:cites_eu_reptilia){
    create_cites_eu_class(
      :taxonomic_position => '1.1.3',
      :taxon_name => create(:taxon_name, :scientific_name => 'Reptilia'),
      :parent => cites_eu_chordata
    )
  }
  let(:cites_eu_amphibia){
    create_cites_eu_class(
      :taxonomic_position => '1.1.4',
      :taxon_name => create(:taxon_name, :scientific_name => 'Amphibia'),
      :parent => cites_eu_chordata
    )
  }
  let(:cites_eu_arthropoda){
    create_cites_eu_phylum(
      :taxonomic_position => '1.3',
      :taxon_name => create(:taxon_name, :scientific_name => 'Arthropoda'),
      :parent => cites_eu_animalia
    )
  }
  let(:cites_eu_insecta){
    create_cites_eu_class(
      :taxonomic_position => '1.3.2',
      :taxon_name => create(:taxon_name, :scientific_name => 'Insecta'),
      :parent => cites_eu_arthropoda
    )
  }
  let(:cites_eu_annelida){
    create_cites_eu_phylum(
      :taxonomic_position => '1.4',
      :taxon_name => create(:taxon_name, :scientific_name => 'Annelida'),
      :parent => cites_eu_animalia
    )
  }
  let(:cites_eu_hirudinoidea){
    create_cites_eu_class(
      :taxonomic_position => '1.4.1',
      :taxon_name => create(:taxon_name, :scientific_name => 'Hirudinoidea'),
      :parent => cites_eu_annelida
    )
  }
  let(:cites_eu_plantae){
    create_cites_eu_kingdom(
      :taxonomic_position => '2',
      :taxon_name => create(:taxon_name, :scientific_name => 'Plantae')
    )
  }

  %w(kingdom phylum class order family subfamily genus species subspecies variety).each do |rank|
    define_method "create_#{rank}" do |options = {}|
      create(
        :taxon_concept,
        options.merge({:rank => send("#{rank}_rank")})
      )
    end
    define_method "build_#{rank}" do |options = {}|
      build(
        :taxon_concept,
        options.merge({:rank => send("#{rank}_rank")})
      )
    end
    define_method "create_cites_eu_#{rank}" do |options = {}|
      create(
        :taxon_concept,
        options.merge({
          :rank => send("#{rank}_rank"),
          :taxonomy => cites_eu
        })
      )
    end
    define_method "build_cites_eu_#{rank}" do |options = {}|
      build(
        :taxon_concept,
        options.merge({
          :rank => send("#{rank}_rank"),
          :taxonomy => cites_eu
        })
      )
    end
    define_method "create_cms_#{rank}" do |options = {}|
      create(
        :taxon_concept,
        options.merge({
          :rank => send("#{rank}_rank"),
          :taxonomy => cms
        })
      )
    end
    define_method "build_cms_#{rank}" do |options = {}|
      build(
        :taxon_concept,
        options.merge({
          :rank => send("#{rank}_rank"),
          :taxonomy => cms
        })
      )
    end
  end

  def create_cites_cop(options = {})
    create(
      :cites_cop,
      options.merge({:designation => cites})
    )
  end
  def create_cites_suspension_notification(options = {})
    create(
      :cites_suspension_notification,
      options.merge({:designation => cites})
    )
  end
  def create_eu_regulation(options = {})
    create(
      :eu_regulation,
      options.merge({:designation => eu})
    )
  end
  def build_cites_cop(options = {})
    build(
      :cites_cop,
      options.merge({:designation => cites})
    )
  end
  def build_eu_regulation(options = {})
    build(
      :eu_regulation,
      options.merge({:designation => eu})
    )
  end
  def build_cites_suspension_notification(options = {})
    build(
      :cites_suspension_notification,
      options.merge({:designation => cites})
    )
  end
end

module SapiSpec
  module Helpers
    def self.included(scope)
      scope.include_context :sapi
    end
  end
end
