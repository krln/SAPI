# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130702093702) do

  create_table "annotations", :force => true do |t|
    t.string   "symbol"
    t.string   "parent_symbol"
    t.boolean  "display_in_index",    :default => false, :null => false
    t.boolean  "display_in_footnote", :default => false, :null => false
    t.text     "short_note_en"
    t.text     "full_note_en"
    t.text     "short_note_fr"
    t.text     "full_note_fr"
    t.text     "short_note_es"
    t.text     "full_note_es"
    t.integer  "source_id"
    t.integer  "event_id"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  create_table "change_types", :force => true do |t|
    t.string   "name",           :null => false
    t.integer  "designation_id", :null => false
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "cites_suspension_confirmations", :force => true do |t|
    t.integer  "cites_suspension_id",              :null => false
    t.integer  "cites_suspension_notification_id", :null => false
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
  end

  create_table "common_names", :force => true do |t|
    t.string   "name",        :null => false
    t.integer  "language_id", :null => false
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "designation_geo_entities", :force => true do |t|
    t.integer  "designation_id", :null => false
    t.integer  "geo_entity_id",  :null => false
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "designations", :force => true do |t|
    t.string   "name",                       :null => false
    t.integer  "taxonomy_id", :default => 1, :null => false
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  create_table "distribution_references", :force => true do |t|
    t.integer "distribution_id", :null => false
    t.integer "reference_id",    :null => false
  end

  add_index "distribution_references", ["distribution_id", "reference_id"], :name => "index_distribution_references_on_distribution_id_and_ref_id"

  create_table "distributions", :force => true do |t|
    t.integer  "taxon_concept_id", :null => false
    t.integer  "geo_entity_id",    :null => false
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "downloads", :force => true do |t|
    t.string   "doc_type"
    t.string   "format"
    t.string   "status",       :default => "working"
    t.string   "path"
    t.string   "filename"
    t.string   "display_name"
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
  end

  create_table "eu_decisions", :force => true do |t|
    t.string   "type"
    t.integer  "law_id"
    t.integer  "taxon_concept_id"
    t.integer  "geo_entity_id"
    t.datetime "start_date"
    t.datetime "end_date"
    t.string   "restriction"
    t.text     "restriction_text"
    t.integer  "term_id"
    t.integer  "source_id"
    t.boolean  "conditions"
    t.text     "comments"
    t.boolean  "is_current"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.boolean  "conditions_apply"
  end

  create_table "events", :force => true do |t|
    t.string   "name"
    t.integer  "designation_id"
    t.text     "description"
    t.text     "url"
    t.boolean  "is_current",     :default => false,   :null => false
    t.string   "type",           :default => "Event", :null => false
    t.datetime "effective_at"
    t.datetime "published_at"
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
    t.integer  "legacy_id"
    t.datetime "end_date"
    t.string   "subtype"
  end

  create_table "geo_entities", :force => true do |t|
    t.integer  "geo_entity_type_id",                   :null => false
    t.string   "name_en",                              :null => false
    t.string   "name_fr"
    t.string   "name_es"
    t.string   "long_name"
    t.string   "iso_code2"
    t.string   "iso_code3"
    t.integer  "legacy_id"
    t.string   "legacy_type"
    t.boolean  "is_current",         :default => true
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
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

  create_table "instruments", :force => true do |t|
    t.integer  "designation_id"
    t.string   "name"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "languages", :force => true do |t|
    t.string   "name_en",    :null => false
    t.string   "name_fr"
    t.string   "name_es"
    t.string   "iso_code1"
    t.string   "iso_code3",  :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "listing_changes", :force => true do |t|
    t.integer  "taxon_concept_id",                                              :null => false
    t.integer  "species_listing_id"
    t.integer  "change_type_id",                                                :null => false
    t.integer  "annotation_id"
    t.integer  "hash_annotation_id"
    t.datetime "effective_at",               :default => '2012-09-21 07:32:20', :null => false
    t.boolean  "is_current",                 :default => false,                 :null => false
    t.integer  "parent_id"
    t.integer  "inclusion_taxon_concept_id"
    t.integer  "event_id"
    t.integer  "source_id"
    t.boolean  "explicit_change",            :default => true
    t.datetime "created_at",                                                    :null => false
    t.datetime "updated_at",                                                    :null => false
  end

  add_index "listing_changes", ["annotation_id"], :name => "index_listing_changes_on_annotation_id"
  add_index "listing_changes", ["event_id"], :name => "index_listing_changes_on_event_id"
  add_index "listing_changes", ["hash_annotation_id"], :name => "index_listing_changes_on_hash_annotation_id"
  add_index "listing_changes", ["parent_id"], :name => "index_listing_changes_on_parent_id"

  create_table "listing_changes_mview", :id => false, :force => true do |t|
    t.integer  "id"
    t.integer  "taxon_concept_id"
    t.datetime "effective_at"
    t.integer  "species_listing_id"
    t.string   "species_listing_name"
    t.integer  "change_type_id"
    t.string   "change_type_name"
    t.integer  "designation_id"
    t.string   "designation_name"
    t.integer  "party_id"
    t.string   "party_iso_code"
    t.string   "ann_symbol"
    t.text     "full_note_en"
    t.text     "full_note_es"
    t.text     "full_note_fr"
    t.text     "short_note_en"
    t.text     "short_note_es"
    t.text     "short_note_fr"
    t.boolean  "display_in_index"
    t.boolean  "display_in_footnote"
    t.string   "hash_ann_symbol"
    t.string   "hash_ann_parent_symbol"
    t.text     "hash_full_note_en"
    t.text     "hash_full_note_es"
    t.text     "hash_full_note_fr"
    t.boolean  "is_current"
    t.boolean  "explicit_change"
    t.string   "countries_ids_ary",      :limit => nil
    t.boolean  "dirty"
    t.datetime "expiry"
  end

  create_table "listing_distributions", :force => true do |t|
    t.integer  "listing_change_id",                   :null => false
    t.integer  "geo_entity_id",                       :null => false
    t.boolean  "is_party",          :default => true, :null => false
    t.integer  "source_id"
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
  end

  add_index "listing_distributions", ["geo_entity_id"], :name => "index_listing_distributions_on_geo_entity_id"
  add_index "listing_distributions", ["listing_change_id"], :name => "index_listing_distributions_on_listing_change_id"

  create_table "preset_tags", :force => true do |t|
    t.string   "name"
    t.string   "model"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "ranks", :force => true do |t|
    t.string   "name",                                  :null => false
    t.string   "taxonomic_position", :default => "0",   :null => false
    t.boolean  "fixed_order",        :default => false, :null => false
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
  end

  create_table "references", :force => true do |t|
    t.text     "title",       :null => false
    t.string   "year"
    t.string   "author"
    t.text     "citation"
    t.text     "publisher"
    t.integer  "legacy_id"
    t.string   "legacy_type"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "references_legacy_id_mapping", :force => true do |t|
    t.integer "legacy_id",       :null => false
    t.text    "legacy_type",     :null => false
    t.integer "alias_legacy_id", :null => false
  end

  create_table "species_listings", :force => true do |t|
    t.integer  "designation_id", :null => false
    t.string   "name",           :null => false
    t.string   "abbreviation"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       :limit => 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "taxon_commons", :force => true do |t|
    t.integer  "taxon_concept_id", :null => false
    t.integer  "common_name_id",   :null => false
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "taxon_concept_references", :force => true do |t|
    t.integer  "taxon_concept_id",                                              :null => false
    t.integer  "reference_id",                                                  :null => false
    t.boolean  "is_standard",                                :default => false, :null => false
    t.boolean  "is_cascaded",                                :default => false, :null => false
    t.datetime "created_at",                                                    :null => false
    t.datetime "updated_at",                                                    :null => false
    t.string   "excluded_taxon_concepts_ids", :limit => nil
  end

  add_index "taxon_concept_references", ["taxon_concept_id", "reference_id"], :name => "index_taxon_concept_references_on_taxon_concept_id_and_ref_id"

  create_table "taxon_concepts", :force => true do |t|
    t.integer  "taxonomy_id",        :default => 1,   :null => false
    t.integer  "parent_id"
    t.integer  "rank_id",                             :null => false
    t.integer  "taxon_name_id",                       :null => false
    t.string   "author_year"
    t.integer  "legacy_id"
    t.string   "legacy_type"
    t.hstore   "data"
    t.hstore   "listing"
    t.text     "notes"
    t.string   "taxonomic_position", :default => "0", :null => false
    t.string   "full_name"
    t.string   "name_status",        :default => "A", :null => false
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
  end

  add_index "taxon_concepts", ["parent_id"], :name => "index_taxon_concepts_on_parent_id"

  create_table "taxon_concepts_mview", :id => false, :force => true do |t|
    t.integer  "id"
    t.integer  "parent_id"
    t.boolean  "taxonomy_is_cites_eu"
    t.string   "full_name"
    t.string   "name_status"
    t.text     "rank_name"
    t.boolean  "spp"
    t.boolean  "cites_accepted"
    t.integer  "kingdom_position"
    t.string   "taxonomic_position"
    t.text     "kingdom_name"
    t.text     "phylum_name"
    t.text     "class_name"
    t.text     "order_name"
    t.text     "family_name"
    t.text     "genus_name"
    t.text     "species_name"
    t.text     "subspecies_name"
    t.integer  "kingdom_id"
    t.integer  "phylum_id"
    t.integer  "class_id"
    t.integer  "order_id"
    t.integer  "family_id"
    t.integer  "genus_id"
    t.integer  "species_id"
    t.integer  "subspecies_id"
    t.boolean  "cites_i"
    t.boolean  "cites_ii"
    t.boolean  "cites_iii"
    t.boolean  "cites_listed"
    t.boolean  "cites_show"
    t.boolean  "cites_status_original"
    t.text     "cites_status"
    t.text     "cites_listing_original"
    t.text     "cites_listing"
    t.integer  "cites_closest_listed_ancestor_id"
    t.datetime "cites_listing_updated_at"
    t.text     "ann_symbol"
    t.text     "hash_ann_symbol"
    t.text     "hash_ann_parent_symbol"
    t.boolean  "eu_listed"
    t.boolean  "eu_show"
    t.boolean  "eu_status_original"
    t.text     "eu_status"
    t.text     "eu_listing_original"
    t.text     "eu_listing"
    t.integer  "eu_closest_listed_ancestor_id"
    t.datetime "eu_listing_updated_at"
    t.string   "species_listings_ids",             :limit => nil
    t.string   "species_listings_ids_aggregated",  :limit => nil
    t.string   "author_year"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "taxon_concept_id_com"
    t.string   "english_names_ary",                :limit => nil
    t.string   "spanish_names_ary",                :limit => nil
    t.string   "french_names_ary",                 :limit => nil
    t.integer  "taxon_concept_id_syn"
    t.string   "synonyms_ary",                     :limit => nil
    t.string   "synonyms_author_years_ary",        :limit => nil
    t.string   "countries_ids_ary",                :limit => nil
    t.boolean  "dirty"
    t.datetime "expiry"
  end

  create_table "taxon_instruments", :force => true do |t|
    t.integer  "taxon_concept_id"
    t.integer  "instrument_id"
    t.datetime "effective_from"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "taxon_names", :force => true do |t|
    t.string   "scientific_name", :null => false
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "taxon_relationship_types", :force => true do |t|
    t.string   "name",                                 :null => false
    t.boolean  "is_intertaxonomic", :default => false, :null => false
    t.boolean  "is_bidirectional",  :default => false, :null => false
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
  end

  create_table "taxon_relationships", :force => true do |t|
    t.integer  "taxon_concept_id",           :null => false
    t.integer  "other_taxon_concept_id",     :null => false
    t.integer  "taxon_relationship_type_id", :null => false
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  create_table "taxonomies", :force => true do |t|
    t.string   "name",       :default => "DEAFAULT TAXONOMY", :null => false
    t.datetime "created_at",                                  :null => false
    t.datetime "updated_at",                                  :null => false
  end

  create_table "trade_annual_report_uploads", :force => true do |t|
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
    t.boolean  "is_done",            :default => false
    t.integer  "number_of_rows"
    t.text     "csv_source_file"
    t.integer  "trading_country_id",                    :null => false
    t.string   "point_of_view",      :default => "E",   :null => false
  end

  create_table "trade_codes", :force => true do |t|
    t.string   "code",       :null => false
    t.string   "type",       :null => false
    t.string   "name_en",    :null => false
    t.string   "name_es"
    t.string   "name_fr"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "trade_exporter_permits", :force => true do |t|
    t.integer  "trade_permit_id"
    t.integer  "trade_shipment_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "trade_permits", :force => true do |t|
    t.string   "number"
    t.integer  "geo_entity_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "trade_restriction_purposes", :force => true do |t|
    t.integer  "trade_restriction_id"
    t.integer  "purpose_id"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
  end

  create_table "trade_restriction_sources", :force => true do |t|
    t.integer  "trade_restriction_id"
    t.integer  "source_id"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
  end

  create_table "trade_restriction_terms", :force => true do |t|
    t.integer  "trade_restriction_id"
    t.integer  "term_id"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
  end

  create_table "trade_restrictions", :force => true do |t|
    t.boolean  "is_current"
    t.datetime "start_date"
    t.datetime "end_date"
    t.integer  "geo_entity_id"
    t.float    "quota"
    t.datetime "publication_date"
    t.text     "notes"
    t.string   "type"
    t.integer  "unit_id"
    t.integer  "taxon_concept_id"
    t.boolean  "public_display",                             :default => true
    t.text     "url"
    t.datetime "created_at",                                                   :null => false
    t.datetime "updated_at",                                                   :null => false
    t.integer  "start_notification_id"
    t.integer  "end_notification_id"
    t.string   "excluded_taxon_concepts_ids", :limit => nil
  end

  create_table "trade_sandbox_template", :force => true do |t|
    t.string "appendix"
    t.string "species_name"
    t.string "term_code"
    t.string "quantity"
    t.string "unit_code"
    t.string "trading_partner"
    t.string "country_of_origin"
    t.string "export_permit"
    t.string "origin_permit"
    t.string "purpose_code"
    t.string "source_code"
    t.string "year"
    t.string "import_permit"
  end

  create_table "trade_shipments", :force => true do |t|
    t.integer  "source_id"
    t.integer  "unit_id"
    t.integer  "purpose_id"
    t.integer  "term_id"
    t.decimal  "quantity"
    t.string   "reported_appendix"
    t.string   "appendix"
    t.integer  "trade_annual_report_upload_id"
    t.integer  "exporter_id"
    t.integer  "importer_id"
    t.integer  "country_of_origin_id"
    t.integer  "country_of_origin_permit_id"
    t.integer  "import_permit_id"
    t.boolean  "reported_by_exporter"
    t.integer  "taxon_concept_id"
    t.string   "reported_species_name"
    t.integer  "year"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  create_table "trade_validation_rules", :force => true do |t|
    t.string   "valid_values_view"
    t.string   "type",              :null => false
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.string   "format_re"
    t.integer  "run_order",         :null => false
    t.string   "column_names"
  end

  create_table "users", :force => true do |t|
    t.string   "name",       :null => false
    t.string   "email",      :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_foreign_key "annotations", "annotations", :name => "annotations_source_id_fk", :column => "source_id"
  add_foreign_key "annotations", "events", :name => "annotations_event_id_fk"

  add_foreign_key "change_types", "designations", :name => "change_types_designation_id_fk"

  add_foreign_key "cites_suspension_confirmations", "events", :name => "cites_suspension_confirmations_notification_id_fk", :column => "cites_suspension_notification_id"
  add_foreign_key "cites_suspension_confirmations", "trade_restrictions", :name => "cites_suspension_confirmations_cites_suspension_id_fk", :column => "cites_suspension_id"

  add_foreign_key "common_names", "languages", :name => "common_names_language_id_fk"

  add_foreign_key "designation_geo_entities", "designations", :name => "designation_geo_entities_designation_id_fk"
  add_foreign_key "designation_geo_entities", "geo_entities", :name => "designation_geo_entities_geo_entity_id_fk"

  add_foreign_key "designations", "taxonomies", :name => "designations_taxonomy_id_fk"

  add_foreign_key "distribution_references", "distributions", :name => "taxon_concept_geo_entity_references_taxon_concept_geo_entity_fk"
  add_foreign_key "distribution_references", "references", :name => "taxon_concept_geo_entity_references_reference_id_fk"

  add_foreign_key "distributions", "geo_entities", :name => "taxon_concept_geo_entities_geo_entity_id_fk"
  add_foreign_key "distributions", "taxon_concepts", :name => "taxon_concept_geo_entities_taxon_concept_id_fk"

  add_foreign_key "eu_decisions", "events", :name => "eu_decisions_law_id_fk", :column => "law_id"
  add_foreign_key "eu_decisions", "geo_entities", :name => "eu_decisions_geo_entity_id_fk"
  add_foreign_key "eu_decisions", "taxon_concepts", :name => "eu_decisions_taxon_concept_id_fk"
  add_foreign_key "eu_decisions", "trade_codes", :name => "eu_decisions_source_id_fk", :column => "source_id"
  add_foreign_key "eu_decisions", "trade_codes", :name => "eu_decisions_term_id_fk", :column => "term_id"

  add_foreign_key "events", "designations", :name => "events_designation_id_fk"

  add_foreign_key "geo_entities", "geo_entity_types", :name => "geo_entities_geo_entity_type_id_fk"

  add_foreign_key "geo_relationships", "geo_entities", :name => "geo_relationships_geo_entity_id_fk"
  add_foreign_key "geo_relationships", "geo_entities", :name => "geo_relationships_other_geo_entity_id_fk", :column => "other_geo_entity_id"
  add_foreign_key "geo_relationships", "geo_relationship_types", :name => "geo_relationships_geo_relationship_type_id_fk"

  add_foreign_key "instruments", "designations", :name => "instruments_designation_id_fk"

  add_foreign_key "listing_changes", "annotations", :name => "listing_changes_annotation_id_fk"
  add_foreign_key "listing_changes", "annotations", :name => "listing_changes_hash_annotation_id_fk", :column => "hash_annotation_id"
  add_foreign_key "listing_changes", "change_types", :name => "listing_changes_change_type_id_fk"
  add_foreign_key "listing_changes", "events", :name => "listing_changes_event_id_fk"
  add_foreign_key "listing_changes", "listing_changes", :name => "listing_changes_parent_id_fk", :column => "parent_id"
  add_foreign_key "listing_changes", "listing_changes", :name => "listing_changes_source_id_fk", :column => "source_id"
  add_foreign_key "listing_changes", "species_listings", :name => "listing_changes_species_listing_id_fk"
  add_foreign_key "listing_changes", "taxon_concepts", :name => "listing_changes_inclusion_taxon_concept_id_fk", :column => "inclusion_taxon_concept_id"
  add_foreign_key "listing_changes", "taxon_concepts", :name => "listing_changes_taxon_concept_id_fk"

  add_foreign_key "listing_distributions", "geo_entities", :name => "listing_distributions_geo_entity_id_fk"
  add_foreign_key "listing_distributions", "listing_changes", :name => "listing_distributions_listing_change_id_fk"
  add_foreign_key "listing_distributions", "listing_distributions", :name => "listing_distributions_source_id_fk", :column => "source_id"

  add_foreign_key "species_listings", "designations", :name => "species_listings_designation_id_fk"

  add_foreign_key "taxon_commons", "common_names", :name => "taxon_commons_common_name_id_fk"
  add_foreign_key "taxon_commons", "taxon_concepts", :name => "taxon_commons_taxon_concept_id_fk"

  add_foreign_key "taxon_concept_references", "references", :name => "taxon_concept_references_reference_id_fk"
  add_foreign_key "taxon_concept_references", "taxon_concepts", :name => "taxon_concept_references_taxon_concept_id_fk"

  add_foreign_key "taxon_concepts", "ranks", :name => "taxon_concepts_rank_id_fk"
  add_foreign_key "taxon_concepts", "taxon_concepts", :name => "taxon_concepts_parent_id_fk", :column => "parent_id"
  add_foreign_key "taxon_concepts", "taxon_names", :name => "taxon_concepts_taxon_name_id_fk"
  add_foreign_key "taxon_concepts", "taxonomies", :name => "taxon_concepts_taxonomy_id_fk"

  add_foreign_key "taxon_instruments", "instruments", :name => "taxon_instruments_instrument_id_fk"
  add_foreign_key "taxon_instruments", "taxon_concepts", :name => "taxon_instruments_taxon_concept_id_fk"

  add_foreign_key "taxon_relationships", "taxon_concepts", :name => "taxon_relationships_taxon_concept_id_fk"
  add_foreign_key "taxon_relationships", "taxon_relationship_types", :name => "taxon_relationships_taxon_relationship_type_id_fk"

  add_foreign_key "trade_annual_report_uploads", "geo_entities", :name => "trade_annual_report_uploads_trading_country_id_fk", :column => "trading_country_id"
  add_foreign_key "trade_annual_report_uploads", "users", :name => "trade_annual_report_uploads_created_by_fk", :column => "created_by"
  add_foreign_key "trade_annual_report_uploads", "users", :name => "trade_annual_report_uploads_updated_by_fk", :column => "updated_by"

  add_foreign_key "trade_exporter_permits", "trade_permits", :name => "trade_exporter_permits_trade_permit_id_fk"
  add_foreign_key "trade_exporter_permits", "trade_permits", :name => "trade_exporter_permits_trade_shipment_id_fk", :column => "trade_shipment_id"

  add_foreign_key "trade_permits", "geo_entities", :name => "trade_permits_geo_entity_id_fk"

  add_foreign_key "trade_restriction_purposes", "trade_codes", :name => "trade_restriction_purposes_purpose_id", :column => "purpose_id"
  add_foreign_key "trade_restriction_purposes", "trade_restrictions", :name => "trade_restriction_purposes_trade_restriction_id"

  add_foreign_key "trade_restriction_sources", "trade_codes", :name => "trade_restriction_sources_source_id", :column => "source_id"
  add_foreign_key "trade_restriction_sources", "trade_restrictions", :name => "trade_restriction_sources_trade_restriction_id"

  add_foreign_key "trade_restriction_terms", "trade_codes", :name => "trade_restriction_terms_term_id", :column => "term_id"
  add_foreign_key "trade_restriction_terms", "trade_restrictions", :name => "trade_restriction_terms_trade_restriction_id"

  add_foreign_key "trade_restrictions", "events", :name => "trade_restrictions_end_notification_id_fk", :column => "end_notification_id"
  add_foreign_key "trade_restrictions", "events", :name => "trade_restrictions_start_notification_id_fk", :column => "start_notification_id"
  add_foreign_key "trade_restrictions", "geo_entities", :name => "trade_restrictions_geo_entity_id_fk"
  add_foreign_key "trade_restrictions", "taxon_concepts", :name => "trade_restrictions_taxon_concept_id_fk"
  add_foreign_key "trade_restrictions", "trade_codes", :name => "trade_restrictions_unit_id_fk", :column => "unit_id"

  add_foreign_key "trade_shipments", "geo_entities", :name => "trade_shipments_country_of_origin_id_fk", :column => "country_of_origin_id"
  add_foreign_key "trade_shipments", "geo_entities", :name => "trade_shipments_exporter_id_fk", :column => "exporter_id"
  add_foreign_key "trade_shipments", "geo_entities", :name => "trade_shipments_importer_id_fk", :column => "importer_id"
  add_foreign_key "trade_shipments", "taxon_concepts", :name => "trade_shipments_taxon_concept_id_fk"
  add_foreign_key "trade_shipments", "trade_annual_report_uploads", :name => "trade_shipments_trade_annual_report_upload_id_fk"
  add_foreign_key "trade_shipments", "trade_codes", :name => "trade_shipments_purpose_id_fk", :column => "purpose_id"
  add_foreign_key "trade_shipments", "trade_codes", :name => "trade_shipments_source_id_fk", :column => "source_id"
  add_foreign_key "trade_shipments", "trade_codes", :name => "trade_shipments_term_id_fk", :column => "term_id"
  add_foreign_key "trade_shipments", "trade_codes", :name => "trade_shipments_unit_id_fk", :column => "unit_id"
  add_foreign_key "trade_shipments", "trade_permits", :name => "trade_shipments_country_of_origin_permit_id_fk", :column => "country_of_origin_permit_id"
  add_foreign_key "trade_shipments", "trade_permits", :name => "trade_shipments_import_permit_id_fk", :column => "import_permit_id"

end
