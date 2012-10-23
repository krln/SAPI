class MergedMigrations < ActiveRecord::Migration
  def change
  create_table "annotation_translations", :force => true do |t|
    t.integer  "annotation_id", :null => false
    t.integer  "language_id",   :null => false
    t.string   "short_note"
    t.text     "full_note",     :null => false
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "annotations", :force => true do |t|
    t.string   "symbol"
    t.string   "parent_symbol"
    t.integer  "listing_change_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "change_types", :force => true do |t|
    t.string   "name"
    t.integer  "designation_id", :null => false
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "common_names", :force => true do |t|
    t.string   "name"
    t.integer  "reference_id"
    t.integer  "language_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "designations", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "geo_entities", :force => true do |t|
    t.integer  "geo_entity_type_id", :null => false
    t.string   "name",               :null => false
    t.string   "long_name"
    t.string   "iso_code2"
    t.string   "iso_code3"
    t.integer  "legacy_id"
    t.string   "legacy_type"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "geo_entity_types", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "geo_relationship_types", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "geo_relationships", :force => true do |t|
    t.integer  "geo_entity_id",            :null => false
    t.integer  "other_geo_entity_id",      :null => false
    t.integer  "geo_relationship_type_id", :null => false
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  create_table "languages", :force => true do |t|
    t.string   "name"
    t.string   "abbreviation"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "listing_changes", :force => true do |t|
    t.integer  "species_listing_id"
    t.integer  "taxon_concept_id"
    t.integer  "change_type_id"
    t.integer  "reference_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.integer  "parent_id"
    t.datetime "created_at",                                            :null => false
    t.datetime "updated_at",                                            :null => false
    t.datetime "effective_at",       :default => '2012-09-21 07:32:20', :null => false
    t.integer  "annotation_id"
  end

  add_index "listing_changes", ["annotation_id"], :name => "index_listing_changes_on_annotation_id"

  create_table "listing_distributions", :force => true do |t|
    t.integer  "listing_change_id",                   :null => false
    t.integer  "geo_entity_id",                       :null => false
    t.boolean  "is_party",          :default => true, :null => false
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
  end

  add_index "listing_distributions", ["geo_entity_id"], :name => "index_listing_distributions_on_geo_entity_id"

  create_table "ranks", :force => true do |t|
    t.string   "name",       :null => false
    t.integer  "parent_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "references", :force => true do |t|
    t.text     "title",       :null => false
    t.string   "year"
    t.string   "author"
    t.integer  "legacy_id"
    t.string   "legacy_type"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "species_listings", :force => true do |t|
    t.integer  "designation_id"
    t.string   "name"
    t.string   "abbreviation"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "standard_references", :force => true do |t|
    t.string   "author"
    t.text     "title"
    t.integer  "year"
    t.integer  "reference_id"
    t.integer  "reference_legacy_id"
    t.string   "taxon_concept_name"
    t.string   "taxon_concept_rank"
    t.integer  "taxon_concept_id"
    t.integer  "species_legacy_id"
    t.integer  "position"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  create_table "taxon_commons", :force => true do |t|
    t.integer  "taxon_concept_id"
    t.integer  "common_name_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "taxon_concept_geo_entities", :force => true do |t|
    t.integer  "taxon_concept_id", :null => false
    t.integer  "geo_entity_id",    :null => false
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "taxon_concept_geo_entity_references", :force => true do |t|
    t.integer "taxon_concept_geo_entity_id"
    t.integer "reference_id"
  end

  create_table "taxon_concept_references", :force => true do |t|
    t.integer "taxon_concept_id",     :null => false
    t.integer "reference_id",         :null => false
    t.hstore  "data"
  end

  create_table "taxon_concepts", :force => true do |t|
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.integer  "rank_id",                          :null => false
    t.integer  "designation_id",                   :null => false
    t.integer  "taxon_name_id",                    :null => false
    t.integer  "legacy_id"
    t.string   "legacy_type"
    t.hstore   "data"
    t.boolean  "fully_covered",  :default => true, :null => false
    t.hstore   "listing"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
  end

  add_index "taxon_concepts", ["data"], :name => "index_taxon_concepts_on_data"
  add_index "taxon_concepts", ["lft"], :name => "index_taxon_concepts_on_lft"

  create_table "taxon_names", :force => true do |t|
    t.string   "scientific_name", :null => false
    t.integer  "basionym_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "taxon_relationship_types", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "taxon_relationships", :force => true do |t|
    t.integer  "taxon_concept_id",           :null => false
    t.integer  "other_taxon_concept_id",     :null => false
    t.integer  "taxon_relationship_type_id", :null => false
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  add_foreign_key "annotation_translations", "annotations", :name => "annotation_translations_annotation_id_fk"
  add_foreign_key "annotation_translations", "languages", :name => "annotation_translations_language_id_fk"

  add_foreign_key "annotations", "listing_changes", :name => "annotations_listing_changes_id_fk"

  add_foreign_key "change_types", "designations", :name => "change_types_designation_id_fk"

  add_foreign_key "common_names", "languages", :name => "common_names_language_id_fk"

  add_foreign_key "geo_entities", "geo_entity_types", :name => "geo_entities_geo_entity_type_id_fk"

  add_foreign_key "geo_relationships", "geo_entities", :name => "geo_relationships_geo_entity_id_fk"
  add_foreign_key "geo_relationships", "geo_entities", :name => "geo_relationships_other_geo_entity_id_fk", :column => "other_geo_entity_id"
  add_foreign_key "geo_relationships", "geo_relationship_types", :name => "geo_relationships_geo_relationship_type_id_fk"

  add_foreign_key "listing_changes", "annotations", :name => "listing_changes_annotation_id_fk"
  add_foreign_key "listing_changes", "change_types", :name => "listing_changes_change_type_id_fk"
  add_foreign_key "listing_changes", "listing_changes", :name => "listing_changes_parent_id_fk", :column => "parent_id"
  add_foreign_key "listing_changes", "references", :name => "listing_changes_reference_id_fk"
  add_foreign_key "listing_changes", "species_listings", :name => "listing_changes_species_listing_id_fk"
  add_foreign_key "listing_changes", "taxon_concepts", :name => "listing_changes_taxon_concept_id_fk"

  add_foreign_key "listing_distributions", "geo_entities", :name => "listing_distributions_geo_entity_id_fk"
  add_foreign_key "listing_distributions", "listing_changes", :name => "listing_distributions_listing_change_id_fk"

  add_foreign_key "ranks", "ranks", :name => "ranks_parent_id_fk", :column => "parent_id"

  add_foreign_key "species_listings", "designations", :name => "species_listings_designation_id_fk"

  add_foreign_key "taxon_commons", "common_names", :name => "taxon_commons_common_name_id_fk"
  add_foreign_key "taxon_commons", "taxon_concepts", :name => "taxon_commons_taxon_concept_id_fk"

  add_foreign_key "taxon_concept_geo_entities", "geo_entities", :name => "taxon_concept_geo_entities_geo_entity_id_fk"
  add_foreign_key "taxon_concept_geo_entities", "taxon_concepts", :name => "taxon_concept_geo_entities_taxon_concept_id_fk"

  add_foreign_key "taxon_concept_geo_entity_references", "references", :name => "taxon_concept_geo_entity_references_reference_id_fk"
  add_foreign_key "taxon_concept_geo_entity_references", "taxon_concept_geo_entities", :name => "taxon_concept_geo_entity_references_taxon_concept_geo_entity_fk"

  add_foreign_key "taxon_concept_references", "references", :name => "taxon_concept_references_reference_id_fk"
  add_foreign_key "taxon_concept_references", "taxon_concepts", :name => "taxon_concept_references_taxon_concept_id_fk"

  add_foreign_key "taxon_concepts", "designations", :name => "taxon_concepts_designation_id_fk"
  add_foreign_key "taxon_concepts", "ranks", :name => "taxon_concepts_rank_id_fk"
  add_foreign_key "taxon_concepts", "taxon_concepts", :name => "taxon_concepts_parent_id_fk", :column => "parent_id"
  add_foreign_key "taxon_concepts", "taxon_names", :name => "taxon_concepts_taxon_name_id_fk"

  add_foreign_key "taxon_names", "taxon_names", :name => "taxon_names_basionym_id_fk", :column => "basionym_id"

  add_foreign_key "taxon_relationships", "taxon_concepts", :name => "taxon_relationships_taxon_concept_id_fk"
  add_foreign_key "taxon_relationships", "taxon_relationship_types", :name => "taxon_relationships_taxon_relationship_type_id_fk"

  execute <<-SQL
    CREATE VIEW listing_changes_view AS
    WITH multilingual_annotations AS (
      SELECT annotation_id_mul,
      english_note[1] AS english_full_note, english_note[2] AS english_short_note,
      spanish_note[1] AS spanish_full_note, spanish_note[2] AS spanish_short_note,
      french_note[1] AS french_full_note, french_note[2] AS french_short_note
      FROM
      CROSSTAB(
        'SELECT annotations.id AS annotation_id_mul,
        SUBSTRING(languages.name FROM 1 FOR 1) AS lng,
        ARRAY[annotation_translations.full_note, annotation_translations.short_note]
        FROM "annotations"
        INNER JOIN "annotation_translations"
          ON "annotation_translations"."annotation_id" = "annotations"."id" 
        INNER JOIN "languages"
          ON "languages"."id" = "annotation_translations"."language_id"
        ORDER BY 1,2'
      ) AS ct(
        annotation_id_mul INTEGER,
        english_note TEXT[], spanish_note TEXT[], french_note TEXT[]
      )
    )
    SELECT
      listing_changes.id AS id,
      taxon_concept_id, effective_at,
      species_listing_id,
      species_listings.abbreviation AS species_listing_name,
      change_type_id, change_types.name AS change_type_name,
      listing_distributions.geo_entity_id AS party_id,
      geo_entities.iso_code2 AS party_name,
      generic_annotations.symbol,
      generic_annotations.parent_symbol,
      multilingual_generic_annotations.english_full_note AS generic_english_full_note,
      multilingual_generic_annotations.spanish_full_note AS generic_spanish_full_note,
      multilingual_generic_annotations.french_full_note AS generic_french_full_note,
      multilingual_specific_annotations.english_full_note,
      multilingual_specific_annotations.spanish_full_note,
      multilingual_specific_annotations.french_full_note,
      multilingual_specific_annotations.english_short_note,
      multilingual_specific_annotations.spanish_short_note,
      multilingual_specific_annotations.french_short_note
    FROM
      listing_changes
      LEFT JOIN change_types
        ON listing_changes.change_type_id = change_types.id
      LEFT JOIN species_listings
        ON listing_changes.species_listing_id = species_listings.id
      LEFT JOIN listing_distributions
        ON listing_changes.id = listing_distributions.listing_change_id
        AND listing_distributions.is_party = 't'
      LEFT JOIN geo_entities ON
        geo_entities.id = listing_distributions.geo_entity_id
      LEFT JOIN annotations AS specific_annotations ON
        specific_annotations.listing_change_id = listing_changes.id
      LEFT JOIN annotations AS generic_annotations ON
        generic_annotations.id = listing_changes.annotation_id
      LEFT JOIN multilingual_annotations AS multilingual_specific_annotations
        ON specific_annotations.id = multilingual_specific_annotations.annotation_id_mul
      LEFT JOIN multilingual_annotations AS multilingual_generic_annotations
        ON generic_annotations.id = multilingual_generic_annotations.annotation_id_mul
    ORDER BY taxon_concept_id, effective_at,
    CASE
      WHEN change_types.name = 'ADDITION' THEN 0
      WHEN change_types.name = 'RESERVATION' THEN 1
      WHEN change_types.name = 'RESERVATION_WITHDRAWAL' THEN 2
      WHEN change_types.name = 'DELETION' THEN 3
    END
  SQL
  Sapi::rebuild_listing_changes_mview

  execute <<-SQL
    CREATE OR REPLACE VIEW taxon_concepts_view AS
    SELECT taxon_concepts.id, 
    fully_covered,
    CASE
      WHEN designations.name = 'CITES' THEN ('t')::BOOLEAN
      ELSE ('f')::BOOLEAN
    END AS designation_is_cites,
    data->'full_name' AS full_name,
    data->'rank_name' AS rank_name,
    (data->'cites_accepted')::BOOLEAN AS cites_accepted,
    CASE
      WHEN data->'kingdom_name' = 'Animalia' THEN 0
      ELSE 1
    END AS kingdom_position,
    data->'taxonomic_position' AS taxonomic_position,
    data->'kingdom_name' AS kingdom_name,
    data->'phylum_name' AS phylum_name,
    data->'class_name' AS class_name,
    data->'order_name' AS order_name,
    data->'family_name' AS family_name,
    data->'genus_name' AS genus_name,
    data->'species_name' AS species_name,
    data->'subspecies_name' AS subspecies_name,
    data->'kingdom_id' AS kingdom_id,
    data->'phylum_id' AS phylum_id,
    data->'class_id' AS class_id,
    data->'order_id' AS order_id,
    data->'family_id' AS family_id,
    data->'genus_id' AS genus_id,
    data->'species_id' AS species_id,
    data->'subspecies_id' AS subspecies_id,
    (listing->'cites_listed')::BOOLEAN AS cites_listed,
    (listing->'cites_show')::BOOLEAN AS cites_show,
    CASE
      WHEN listing->'cites_I' = 'I' THEN 't'
      ELSE 'f'
    END AS cites_I,
    CASE
      WHEN listing->'cites_II' = 'II' THEN 't'
      ELSE 'f'
    END AS cites_II,
    CASE
      WHEN listing->'cites_III' = 'III' THEN 't'
      ELSE 'f'
    END AS cites_III,
    (listing->'cites_del')::BOOLEAN AS cites_del,
    listing->'cites_listing' AS current_listing,
    (listing->'usr_cites_exclusion')::BOOLEAN AS usr_cites_exclusion,
    (listing->'cites_exclusion')::BOOLEAN AS cites_exclusion,
    common_names.*,
    synonyms.*,
    countries_ids_ary,
    standard_references_ids_ary
    FROM taxon_concepts
    LEFT JOIN designations
      ON designations.id = taxon_concepts.designation_id
    LEFT JOIN (
      SELECT *
      FROM
      CROSSTAB(
        'SELECT taxon_concepts.id AS taxon_concept_id_com,
        SUBSTRING(languages.name FROM 1 FOR 1) AS lng,
        ARRAY_AGG(common_names.name ORDER BY common_names.id) AS common_names_ary 
        FROM "taxon_concepts"
        INNER JOIN "taxon_commons"
          ON "taxon_commons"."taxon_concept_id" = "taxon_concepts"."id" 
        INNER JOIN "common_names"
          ON "common_names"."id" = "taxon_commons"."common_name_id" 
        INNER JOIN "languages"
          ON "languages"."id" = "common_names"."language_id"
        GROUP BY taxon_concepts.id, SUBSTRING(languages.name FROM 1 FOR 1)
        ORDER BY 1,2'
      ) AS ct(
        taxon_concept_id_com INTEGER,
        english_names_ary VARCHAR[], french_names_ary VARCHAR[], spanish_names_ary VARCHAR[]
      )
    ) common_names ON taxon_concepts.id = common_names.taxon_concept_id_com
    LEFT JOIN (
      SELECT taxon_concepts.id AS taxon_concept_id_syn,
      ARRAY_AGG(synonym_tc.data->'full_name') AS synonyms_ary
      FROM taxon_concepts
      LEFT JOIN taxon_relationships
        ON "taxon_relationships"."taxon_concept_id" = "taxon_concepts"."id"
      LEFT JOIN "taxon_relationship_types"
        ON "taxon_relationship_types"."id" = "taxon_relationships"."taxon_relationship_type_id"
      LEFT JOIN taxon_concepts AS synonym_tc
        ON synonym_tc.id = taxon_relationships.other_taxon_concept_id
      GROUP BY taxon_concepts.id
    ) synonyms ON taxon_concepts.id = synonyms.taxon_concept_id_syn
    LEFT JOIN (
      SELECT taxon_concepts.id AS taxon_concept_id_cnt,
      ARRAY_AGG(geo_entities.id ORDER BY geo_entities.name) AS countries_ids_ary
      FROM taxon_concepts
      LEFT JOIN taxon_concept_geo_entities
        ON "taxon_concept_geo_entities"."taxon_concept_id" = "taxon_concepts"."id"
      LEFT JOIN geo_entities
        ON taxon_concept_geo_entities.geo_entity_id = geo_entities.id
      LEFT JOIN "geo_entity_types"
        ON "geo_entity_types"."id" = "geo_entities"."geo_entity_type_id"
          AND geo_entity_types.name = '#{GeoEntityType::COUNTRY}'
      GROUP BY taxon_concepts.id
    ) countries_ids ON taxon_concepts.id = countries_ids.taxon_concept_id_cnt
    LEFT JOIN (
      WITH RECURSIVE q AS (
        SELECT h, h.id, ARRAY_AGG(reference_id) AS standard_references_ids_ary
        FROM taxon_concepts h
        LEFT JOIN taxon_concept_references
        ON h.id = taxon_concept_references.taxon_concept_id
          AND taxon_concept_references.data->'usr_is_std_ref' = 't'
        WHERE h.parent_id IS NULL
        GROUP BY h.id

        UNION ALL

        SELECT hi, hi.id,
          CASE
            WHEN (hi.data->'usr_no_std_ref')::BOOLEAN = 't' THEN ARRAY[]::INTEGER[]
            ELSE standard_references_ids_ary || reference_id
          END
        FROM q
        JOIN taxon_concepts hi ON hi.parent_id = (q.h).id
        LEFT JOIN taxon_concept_references
        ON hi.id = taxon_concept_references.taxon_concept_id
          AND taxon_concept_references.data->'usr_is_std_ref' = 't'
      )
      SELECT id AS taxon_concept_id_sr,
      ARRAY(SELECT DISTINCT * FROM UNNEST(standard_references_ids_ary) s WHERE s IS NOT NULL)
      AS standard_references_ids_ary
      FROM q
    ) standard_references_ids ON taxon_concepts.id = standard_references_ids.taxon_concept_id_sr
  SQL
  Sapi::rebuild_taxon_concepts_mview

  end
end