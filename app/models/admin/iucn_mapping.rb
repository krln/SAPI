# == Schema Information
#
# Table name: admin_iucn_mappings
#
#  id               :integer          not null, primary key
#  taxon_concept_id :integer
#  iucn_taxon_id    :integer
#  iucn_taxon_name  :string(255)
#  iucn_author      :string(255)
#  iucn_category    :string(255)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  details          :hstore
#  synonym_id       :integer
#

class Admin::IucnMapping < ActiveRecord::Base
  attr_accessible :iucn_author, :iucn_category, :iucn_taxon_id,
    :iucn_taxon_name, :taxon_concept_id, :details, :synonym_id

  serialize :details, ActiveRecord::Coders::Hstore
  belongs_to :taxon_concept
  belongs_to :synonym, :class_name => 'TaxonConcept'

  scope :filter, lambda { |option|
    case option
    when "ALL"
      scoped
    when "MATCHING"
      where('iucn_taxon_id IS NOT NULL')
    when "NON_MATCHING"
      where(:iucn_taxon_id => nil)
    else
      where("details->'match' = ?", option)
    end
  }

  API_URL = 'http://rlapiv3-beta.iucnredlist.org/api/v3/species/'

  def self.create_mappings
    config_location = Rails.root.join('config/secrets.yml')
    config = YAML.load_file(config_location)[Rails.env]
    @token = config['iucn_redlist']

    rank = Rank.where(:name => Rank::SPECIES).first
    taxonomy = Taxonomy.where(:name => Taxonomy::CITES_EU).first

    TaxonConcept.where(:rank_id => rank.id, :name_status => 'A',
                       :taxonomy_id => taxonomy.id).each do |tc|
      map = Admin::IucnMapping.find_or_create_by_taxon_concept_id(tc.id)
      data = fetch_data_for_name tc.full_name
      if data["result"].empty?
        puts "#{tc.full_name} NO MATCH trying synonyms"
        tc.synonyms.each do |syn|
          data = fetch_data_for_name syn.full_name
          if data["result"] && !data["result"].empty?
            map_taxon_concept tc, map, data, syn
            break
          end
        end
      else
        map_taxon_concept tc, map, data
      end
    end
  end

  def self.fetch_data_for_name full_name
    url = URI.escape("#{API_URL}#{full_name.downcase}?token=#{@token}")
    JSON.parse(RestClient.get(url))
  end

  def self.map_taxon_concept tc, map, data, synonym=nil
    begin
      match = data["result"].first
      puts "#{tc.full_name} #{tc.author_year} <=>  #{match["scientific_name"]} #{match["authority"]}"
      map.update_attributes(
        :iucn_taxon_name => match['scientific_name'],
        :iucn_taxon_id => match['taxonid'],
        :iucn_author => match['authority'],
        :iucn_category => match['category'],
        :details => {
          :match => type_of_match(tc, match, synonym),
          :no_matches => data["result"].size
        },
        :synonym_id => synonym.try(:id)
      )
    rescue Exception => e
      puts "#######################################################################"
      puts "########################## EXCEPTION Taxon Concept #{tc.id} ###########"
      puts e.message
    end
  end

  def self.type_of_match tc, match, synonym
    if tc.full_name == match["scientific_name"]
      if tc.author_year == match["authority"]
        "FULL_MATCH"
      else
        "NAME_MATCH"
      end
    elsif synonym.full_name == match["scientific_name"]
      if synonym.author_year == match["authority"]
        "FULL_SYNONYM_MATCH"
      else
        "SYNONYM_MATCH"
      end
    end
  end
end
