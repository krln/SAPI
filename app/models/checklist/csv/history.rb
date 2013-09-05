class Checklist::Csv::History < Checklist::History
  include Checklist::Csv::Document
  include Checklist::Csv::HistoryContent

  def prepare_main_query
    cites = Designation.find_by_name(Designation::CITES)
    @taxon_concepts_rel = MTaxonConcept.
      select(select_columns).
      where(:taxonomy_is_cites_eu => true).
      joins(:listing_changes).where(
        :"listing_changes_mview.show_in_downloads" => true,
        :"listing_changes_mview.designation_id" => cites && cites.id
      ).
      joins('LEFT JOIN geo_entities ON listing_changes_mview.party_id = geo_entities.id').
      order(<<-SQL
        taxonomic_position, effective_at,
        CASE
          WHEN change_type_name = 'ADDITION' THEN 0
          WHEN change_type_name = 'RESERVATION' THEN 1
          WHEN change_type_name = 'RESERVATION_WITHDRAWAL' THEN 2
          WHEN change_type_name = 'DELETION' THEN 3
        END
        SQL
      )
  end

  def select_columns
    [
      "taxon_concepts_mview.id AS taxon_id",
      "taxon_concepts_mview.kingdom_name",
      "taxon_concepts_mview.phylum_name",
      "taxon_concepts_mview.class_name",
      "taxon_concepts_mview.order_name",
      "taxon_concepts_mview.family_name",
      "taxon_concepts_mview.genus_name",
      "LOWER(taxon_concepts_mview.species_name) AS species_name",
      "LOWER(taxon_concepts_mview.subspecies_name) AS subspecies_name",
      "taxon_concepts_mview.full_name",
      "taxon_concepts_mview.author_year",
      "taxon_concepts_mview.rank_name",
      "listing_changes_mview.species_listing_name",
      "listing_changes_mview.party_iso_code",
      "geo_entities.name_en AS party_full_name",
      "listing_changes_mview.change_type_name",
      "to_char(effective_at, 'DD/MM/YYYY') AS effective_at_formatted",
      "listing_changes_mview.is_current",
      "listing_changes_mview.hash_ann_symbol",
      "strip_tags(listing_changes_mview.hash_full_note_en) AS hash_full_note_en",
      "strip_tags(listing_changes_mview.full_note_en) AS full_note_en",
      "strip_tags(listing_changes_mview.short_note_en) AS short_note_en",
      "strip_tags(listing_changes_mview.short_note_es) AS short_note_es",
      "strip_tags(listing_changes_mview.short_note_fr) AS short_note_fr"
    ]
  end
 
  def taxon_concepts_csv_columns
    [
      :id,
      :kingdom_name, :phylum_name, :class_name, :order_name, :family_name,
      :genus_name, :species_name, :subspecies_name,
      :full_name, :author_year, :rank_name
    ]
  end

  def listing_changes_csv_columns
    [
      :species_listing_name, :party_iso_code, :party_full_name,
      :change_type_name, :effective_at_formatted, :is_current,
      :hash_ann_symbol, :hash_full_note_en,
      :full_note_en, :short_note_en, :short_note_es, :short_note_fr
    ]
  end

end
