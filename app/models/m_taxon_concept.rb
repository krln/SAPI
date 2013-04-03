# == Schema Information
#
# Table name: taxon_concepts_mview
#
#  id                         :integer          primary key
#  parent_id                  :integer
#  taxonomy_is_cites_eu       :boolean
#  full_name                  :string(255)
#  name_status                :string(255)
#  rank_name                  :text
#  cites_accepted             :boolean
#  kingdom_position           :integer
#  taxonomic_position         :string(255)
#  kingdom_name               :text
#  phylum_name                :text
#  class_name                 :text
#  order_name                 :text
#  family_name                :text
#  genus_name                 :text
#  species_name               :text
#  subspecies_name            :text
#  kingdom_id                 :integer
#  phylum_id                  :integer
#  class_id                   :integer
#  order_id                   :integer
#  family_id                  :integer
#  genus_id                   :integer
#  species_id                 :integer
#  subspecies_id              :integer
#  cites_fully_covered        :boolean
#  cites_listed               :boolean
#  cites_deleted              :boolean
#  cites_excluded             :boolean
#  cites_show                 :boolean
#  cites_i                    :boolean
#  cites_ii                   :boolean
#  cites_iii                  :boolean
#  current_listing            :text
#  closest_listed_ancestor_id :integer
#  listing_updated_at         :datetime
#  ann_symbol                 :text
#  hash_ann_symbol            :text
#  hash_ann_parent_symbol     :text
#  author_year                :string(255)
#  created_at                 :datetime
#  updated_at                 :datetime
#  taxon_concept_id_com       :integer
#  english_names_ary          :string
#  french_names_ary           :string
#  spanish_names_ary          :string
#  taxon_concept_id_syn       :integer
#  synonyms_ary               :string
#  synonyms_author_years_ary  :string
#  countries_ids_ary          :string
#  dirty                      :boolean
#  expiry                     :datetime
#

class MTaxonConcept < ActiveRecord::Base
  include PgArrayParser
  self.table_name = :taxon_concepts_mview
  self.primary_key = :id

  belongs_to :taxon_concept, :foreign_key => :id
  has_many :listing_changes, :foreign_key => :taxon_concept_id, :class_name => MListingChange
  has_many :current_listing_changes, :foreign_key => :taxon_concept_id,
    :class_name => MListingChange,
    :conditions => "is_current = 't' AND change_type_name <> '#{ChangeType::EXCEPTION}'"
  has_many :current_additions, :foreign_key => :taxon_concept_id,
    :class_name => MListingChange,
    :conditions => "is_current = 't' AND change_type_name = '#{ChangeType::ADDITION}'",
    :order => 'effective_at DESC, species_listing_name ASC'
  belongs_to :closest_listed_ancestor, :class_name => MTaxonConcept
  scope :by_cites_eu_taxonomy, where(:taxonomy_is_cites_eu => true)

  scope :without_non_accepted, where(:name_status => ['A', 'H'])

  scope :without_hidden, where("#{table_name}.cites_show = 't'")

  scope :by_cites_populations_and_appendices, lambda { |cites_regions_ids, countries_ids, appendix_abbreviations=[]|
    MTaxonConceptFilterByAppendixPopulationQuery.new(
      self, appendix_abbreviations, cites_regions_ids + countries_ids
    ).relation
  }

  scope :by_cites_appendices, lambda { |appendix_abbreviations|
    conds = 
    (['I','II','III'] & appendix_abbreviations).map do |abbr|
      "cites_#{abbr} = 't'"
    end
    where(conds.join(' OR '))
   }

  scope :by_scientific_name, lambda { |scientific_name|
    joins(
      <<-SQL
      INNER JOIN (
        SELECT id FROM taxon_concepts_mview
        WHERE (full_name >= '#{TaxonName.lower_bound(scientific_name)}'
          AND full_name < '#{TaxonName.upper_bound(scientific_name)}')
          OR (
            EXISTS (
              SELECT * FROM UNNEST(english_names_ary) name WHERE name ILIKE '%#{scientific_name}%'
              UNION
              SELECT * FROM UNNEST(french_names_ary) name WHERE name ILIKE '#{scientific_name}%'
              UNION
              SELECT * FROM UNNEST(spanish_names_ary) name WHERE name ILIKE '#{scientific_name}%'
            )
          )
      ) matches
      ON matches.id IN (taxon_concepts_mview.id, family_id, order_id, class_id, phylum_id, kingdom_id)
      SQL
    )
  }

  def self_and_descendants
    joins(
      <<-SQL
      INNER JOIN (
        WITH RECURSIVE search_tree(id) AS (
            SELECT id
            FROM #{table_name}
            WHERE id = #{id}
          UNION ALL
            SELECT #{table_name}.id
            FROM search_tree
            JOIN #{table_name} ON #{table_name}.parent_id = search_tree.id
            WHERE NOT #{table_name}.id = ANY(path)
        )
        SELECT id FROM search_tree ORDER BY path
      ) self_and_descendants_ids ON #{table_name}.id = self_and_descendants_ids.id
      SQL
    ).order("taxonomic_position")
  end

  def self.tree_for(instance)
    
  end

  def self.tree_sql_for(instance)
    tree_sql =  <<-SQL

    SQL
  end

  scope :at_level_of_listing, where(:cites_listed => 't')

  scope :taxonomic_layout, order('taxonomic_position')
  scope :alphabetical_layout, order(['kingdom_position', 'full_name'])

  def spp
    if ['GENUS', 'FAMILY', 'SUBFAMILY', 'ORDER'].include?(rank_name)
      'spp.'
    else
      nil
    end
  end

  ['English', 'Spanish', 'French'].each do |lng|
    define_method("#{lng.downcase}_names") do
      sym = :"#{lng.downcase}_names_ary"
      db_ary_to_array(sym)
    end
  end

  def synonyms
    db_ary_to_array :synonyms_ary
  end

  def synonyms_author_years
    db_ary_to_array :synonyms_author_years_ary
  end

  def synonyms_with_authors
    synonyms.each_with_index.map { |syn, idx| "#{syn} #{synonyms_author_years[idx]}" }
  end

  def db_ary_to_array ary
    if respond_to?(ary)
      parse_pg_array( send(ary)|| '').compact.map do |e|
        e.force_encoding('utf-8')
      end
    else
      []
    end
  end

  def matching_names
    (synonyms + english_names + french_names + spanish_names).flatten
  end

  def countries_ids
    if respond_to?(:countries_ids_ary) && countries_ids_ary?
      parse_pg_array(countries_ids_ary || '').compact
    elsif respond_to? :tc_countries_ids_ary
      parse_pg_array(tc_countries_ids_ary || '').compact
    else
      []
    end
  end

  def countries_iso_codes
    CountryDictionary.instance.get_iso_codes_by_ids(countries_ids)
  end

  def countries_full_names
    CountryDictionary.instance.get_names_by_ids(countries_ids)
  end

  def recently_changed
    return (listing_updated_at ? listing_updated_at > 8.year.ago : false)
  end

  ['en', 'es', 'fr'].each do |lng|
    ["hash_full_note_#{lng.downcase}", "full_note_#{lng.downcase}", "short_note_#{lng.downcase}"].each do |method_name|
      define_method(method_name) do
        current_listing_changes.map do |lc|
          note = lc.send(method_name)
          note && "Appendix #{lc.species_listing_name}:" + note || ''
        end.join("\n")
      end
    end
  end

  # returns ancestor from whom listing is inherited
  # def closest_listed_ancestor
  #   # TODO we should precalculate this ancestor
  #   return self if cites_listed
  #   if cites_listed == false
  #     MTaxonConcept.where(
  #     <<-SQL
  #     id IN (
  #       WITH RECURSIVE ancestors AS (
  #         SELECT h.id, h.parent_id, h.cites_listed, h.taxonomic_position
  #         FROM #{MTaxonConcept.table_name} h
  #         WHERE h.id = #{self.id}

  #         UNION ALL

  #         SELECT hi.id, hi.parent_id, hi.cites_listed, hi.taxonomic_position
  #         FROM ancestors
  #         JOIN #{MTaxonConcept.table_name} hi ON hi.id = ancestors.parent_id
  #       )
  #       SELECT id FROM ancestors
  #       WHERE cites_listed = TRUE
  #       ORDER BY taxonomic_position DESC
  #       LIMIT 1
  #     )
  #     SQL
  #     ).first
  #   else
  #     nil
  #   end
  # end

  # returns the ids of parties associated with current listing changes
  def current_parties_ids
    if current_additions.size > 0
      current_additions.map(&:party_id)
    else
      #inherited listing -- find closest ancestor with listing changes
      closest_listed_ancestor &&
        closest_listed_ancestor.current_additions.map(&:party_id) || []
    end.compact
  end

end
