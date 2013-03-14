# == Schema Information
#
# Table name: taxon_concepts
#
#  id                         :integer          not null, primary key
#  parent_id                  :integer
#  rank_id                    :integer          not null
#  taxon_name_id              :integer          not null
#  author_year                :string(255)
#  legacy_id                  :integer
#  legacy_type                :string(255)
#  data                       :hstore
#  listing                    :hstore
#  notes                      :text
#  taxonomic_position         :string(255)      default("0"), not null
#  full_name                  :string(255)
#  name_status                :string(255)      default("A"), not null
#  lft                        :integer
#  rgt                        :integer
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  taxonomy_id                :integer          default(1), not null
#  closest_listed_ancestor_id :integer
#

class TaxonConcept < ActiveRecord::Base
  attr_accessible :parent_id, :taxonomy_id, :rank_id,
    :parent_id, :author_year, :taxon_name_id, :taxonomic_position,
    :legacy_id, :legacy_type, :full_name, :name_status,
    :accepted_scientific_name, :parent_scientific_name, 
    :hybrid_parent_scientific_name, :other_hybrid_parent_scientific_name,
    :tag_list, :references_attributes, :taxon_concept_references_attributes,
    :closest_listed_ancestor_id
  attr_writer :parent_scientific_name
  attr_accessor :accepted_scientific_name, :hybrid_parent_scientific_name,
    :other_hybrid_parent_scientific_name

  acts_as_taggable

  serialize :data, ActiveRecord::Coders::Hstore
  serialize :listing, ActiveRecord::Coders::Hstore

  belongs_to :parent, :class_name => 'TaxonConcept'
  has_many :children, :class_name => 'TaxonConcept', :foreign_key => :parent_id
  belongs_to :rank
  belongs_to :taxonomy
  has_many :designations, :through => :taxonomy
  belongs_to :taxon_name
  has_many :taxon_relationships, :dependent => :destroy
  has_many :inverse_taxon_relationships, :class_name => 'TaxonRelationship',
    :foreign_key => :other_taxon_concept_id, :dependent => :destroy
  has_many :related_taxon_concepts, :class_name => 'TaxonConcept',
    :through => :taxon_relationships
  has_many :synonym_relationships,
    :class_name => 'TaxonRelationship', :dependent => :destroy,
    :conditions => [
      "taxon_relationship_type_id IN
      (SELECT id FROM taxon_relationship_types
        WHERE name = '#{TaxonRelationshipType::HAS_SYNONYM}')"]
  has_many :inverse_synonym_relationships, :class_name => 'TaxonRelationship',
    :foreign_key => :other_taxon_concept_id, :dependent => :destroy,
    :conditions => [
      "taxon_relationship_type_id IN
      (SELECT id FROM taxon_relationship_types
        WHERE name = '#{TaxonRelationshipType::HAS_SYNONYM}')"]
  has_many :synonyms, :class_name => 'TaxonConcept',
    :through => :synonym_relationships, :source => :other_taxon_concept
  has_many :accepted_names, :class_name => 'TaxonConcept',
    :through => :inverse_synonym_relationships, :source => :taxon_concept
  has_many :hybrid_relationships,
    :class_name => 'TaxonRelationship', :dependent => :destroy,
    :conditions => [
      "taxon_relationship_type_id IN
      (SELECT id FROM taxon_relationship_types
        WHERE name = '#{TaxonRelationshipType::HAS_HYBRID}'
      )"
    ]
  has_many :inverse_hybrid_relationships, :class_name => 'TaxonRelationship',
    :foreign_key => :other_taxon_concept_id, :dependent => :destroy,
    :conditions => [
      "taxon_relationship_type_id IN
      (SELECT id FROM taxon_relationship_types
        WHERE name = '#{TaxonRelationshipType::HAS_HYBRID}')"]
  has_many :hybrids, :class_name => 'TaxonConcept',
    :through => :hybrid_relationships, :source => :other_taxon_concept
  has_many :hybrid_parents, :class_name => 'TaxonConcept',
    :through => :inverse_hybrid_relationships, :source => :taxon_concept
  has_many :distributions
  has_many :geo_entities, :through => :distributions
  has_many :listing_changes
  has_many :current_listing_changes, :class_name => 'ListingChange', :conditions => 'is_current = true'
  has_many :species_listings, :through => :listing_changes
  has_many :taxon_commons, :dependent => :destroy, :include => :common_name
  has_many :common_names, :through => :taxon_commons

  has_and_belongs_to_many :references, :join_table => :taxon_concept_references
  accepts_nested_attributes_for :references, :allow_destroy => true

  has_many :taxon_concept_references
  accepts_nested_attributes_for :taxon_concept_references

  has_many :quotas
  has_many :current_quotas, :class_name => 'Quota', :conditions => "is_current = true"

  has_many :suspensions
  has_many :current_suspensions, :class_name => 'Suspension', :conditions => "is_current = true"

  validates :taxonomy_id, :presence => true
  validates :rank_id, :presence => true
  validate :parent_in_same_taxonomy
  validate :parent_at_immediately_higher_rank
  validates :taxon_name_id, :presence => true,
    :unless => lambda { |tc| tc.taxon_name.try(:valid?) }
  validates :taxon_name_id, :uniqueness => { :scope => [:taxonomy_id, :parent_id, :name_status, :author_year] }
  validates :taxonomic_position,
    :presence => true,
    :format => { :with => /\d(\.\d*)*/, :message => "Use prefix notation, e.g. 1.2" },
    :if => :fixed_order_required?

  before_validation :check_taxon_name_exists
  before_validation :check_parent_taxon_concept_exists
  before_validation :check_hybrid_parent_taxon_concept_exists
  before_validation :check_other_hybrid_parent_taxon_concept_exists
  before_validation :check_accepted_taxon_concept_exists
  before_validation :ensure_taxonomic_position

  scope :by_scientific_name, lambda { |scientific_name|
    where(
      <<-SQL
      UPPER(full_name) >= UPPER('#{TaxonName.lower_bound(scientific_name)}')
        AND UPPER(full_name) < UPPER('#{TaxonName.upper_bound(scientific_name)}')
      SQL
    )
  }

  scope :at_parent_ranks, lambda{ |rank|
    joins(
    <<-SQL
      INNER JOIN ranks ON ranks.id = taxon_concepts.rank_id
        AND ranks.taxonomic_position >= '#{rank.parent_rank_lower_bound}'
        AND ranks.taxonomic_position < '#{rank.taxonomic_position}'
    SQL
    )
  }

  scope :at_ancestor_ranks, lambda{ |rank|
    joins(
    <<-SQL
      INNER JOIN ranks ON ranks.id = taxon_concepts.rank_id
        AND ranks.taxonomic_position < '#{rank.taxonomic_position}'
    SQL
    )
  }

  def under_cites_eu?
    self.taxonomy.name == Taxonomy::CITES_EU
  end

  def fixed_order_required?
    rank && rank.fixed_order
  end

  def has_synonyms?
    synonyms.count > 0
  end

  def is_synonym?
    name_status == 'S'
  end

  def has_hybrids?
    hybrids.count > 0
  end

  def is_hybrid?
    name_status == 'H'
  end

  def has_distribution?
    distributions.count > 0
  end

  def rank_name
    data['rank_name']
  end

  def parent_scientific_name
    @parent_scientific_name ||
    parent && parent.full_name
  end

  def can_be_deleted?
    taxon_relationships.count == 0 &&
    children.count == 0 &&
    listing_changes.count == 0 &&
    taxon_commons.count == 0
  end

  private

  def self.sanitize_full_name(some_full_name)
    #strip ranks
    if some_full_name =~ /(.+)\s*(#{Rank.dict.join('|')})\s*$/
      some_full_name = $1
    end
    #strip redundant whitespace between words
    some_full_name = some_full_name.split(/\s/).join(' ').capitalize
  end

  def parent_in_same_taxonomy
    return true unless parent
    if taxonomy_id != parent.taxonomy_id
      errors.add(:parent_id, "must be in same taxonomy")
      return false
    end
  end

  def parent_at_immediately_higher_rank
    return true unless parent 
    return true if (parent.rank.name == 'KINGDOM' && parent.full_name == 'Plantae' && rank.name == 'ORDER')
    unless parent.rank.taxonomic_position >= rank.parent_rank_lower_bound &&
      parent.rank.taxonomic_position < rank.taxonomic_position
      errors.add(:parent_id, "must be at immediately higher rank")
      return false
    end
  end

  def check_taxon_name_exists
    return true unless full_name
    self.full_name = TaxonConcept.sanitize_full_name(full_name)
    scientific_name = if is_synonym? || is_hybrid?
      full_name
    else
      TaxonName.sanitize_scientific_name(self.full_name)
    end

    tn = taxon_name && TaxonName.where(["UPPER(scientific_name) = UPPER(?)", scientific_name]).first
    if tn
      self.taxon_name = tn
      self.taxon_name_id = tn.id
    else
      self.build_taxon_name(:scientific_name => scientific_name)
    end

    true
  end

  def check_hybrid_parent_taxon_concept_exists
    return true unless is_hybrid?
    check_associated_taxon_concept_exists(:hybrid_parent_scientific_name) do |tc|
      inverse_taxon_relationships.build(
        :taxon_concept_id => tc.id,
        :taxon_relationship_type_id => TaxonRelationshipType.
          find_by_name(TaxonRelationshipType::HAS_HYBRID).id
      )
    end
  end

  def check_other_hybrid_parent_taxon_concept_exists
    return true unless is_hybrid?
    check_associated_taxon_concept_exists(:other_hybrid_parent_scientific_name) do |tc|
      inverse_taxon_relationships.build(
        :taxon_concept_id => tc.id,
        :taxon_relationship_type_id => TaxonRelationshipType.
          find_by_name(TaxonRelationshipType::HAS_HYBRID).id
      )
    end
  end

  def check_accepted_taxon_concept_exists
    return true unless is_synonym?
    check_associated_taxon_concept_exists(:accepted_scientific_name) do |tc|
      inverse_taxon_relationships.build(
        :taxon_concept_id => tc.id,
        :taxon_relationship_type_id => TaxonRelationshipType.
          find_by_name(TaxonRelationshipType::HAS_SYNONYM).id
      )
    end
  end

  def check_parent_taxon_concept_exists
    check_associated_taxon_concept_exists(:parent_scientific_name) do |tc|
      self.parent_id = tc.id
    end
  end

  def check_associated_taxon_concept_exists(full_name_attr)
    full_name_var = self.instance_variable_get("@#{full_name_attr}")
    return true if full_name_var.blank?
    tc = TaxonConcept.find_by_full_name_and_name_status(full_name_var, 'A')
    unless tc
      errors.add(full_name_attr, "does not exist")
      return true
    end
    if block_given?
      yield(tc)
    end
    true
  end

  def self.find_by_full_name_and_name_status(full_name, name_status)
    full_name = TaxonConcept.sanitize_full_name(full_name)
    TaxonConcept.
      where([
        "UPPER(full_name) = UPPER(BTRIM(?)) AND name_status = ?",
        full_name,
        name_status
      ]).first
  end

  def ensure_taxonomic_position
    if new_record? && fixed_order_required? && taxonomic_position.blank?
      prev_taxonomic_position =
      if parent
        last_sibling = TaxonConcept.where(:parent_id => parent_id).
          maximum(:taxonomic_position)
        last_sibling || (parent.taxonomic_position + '.0')
      else
        last_root = TaxonConcept.where(:parent_id => nil).
          maximum(:taxonomic_position)
        last_root || '0'
      end
      prev_taxonomic_position_parts = prev_taxonomic_position.split('.')
      prev_taxonomic_position_parts << (prev_taxonomic_position_parts.pop || 0).to_i + 1
      self.taxonomic_position = prev_taxonomic_position_parts.join('.')
    end
    true
  end

end
