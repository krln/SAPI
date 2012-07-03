class ModifyRebuildListingsFixLevelOfListing < ActiveRecord::Migration
  def change
    execute <<-SQL
CREATE OR REPLACE FUNCTION rebuild_listings() RETURNS void
    LANGUAGE plpgsql
    AS $$
        BEGIN
        UPDATE taxon_concepts
        SET listing = ('not_in_cites' => 'NC') || ('cites_listing' => 'NC') || ('cites_show' => 't')
        WHERE not_in_cites = 't' OR fully_covered <> 't';

        UPDATE taxon_concepts
        SET listing =
        CASE
          WHEN taxon_concepts.listing IS NOT NULL THEN taxon_concepts.listing
          ELSE ''::hstore
        END
        || qqq.listing || ('cites_listed' => 't') || ('cites_show' => 't'),
        data = taxon_concepts.data || CASE
          WHEN taxon_concepts.data -> 'rank_name' <> 'SUBSPECIES' AND
            taxon_concepts.data -> 'rank_name' <> 'SPECIES'
          THEN ('spp' => 'spp.')
          ELSE ('spp' => NULL)
        END
        FROM (
          SELECT taxon_concept_id, listing ||
          ('cites_listing' => ARRAY_TO_STRING(
            -- unnest to filter out the nulls
            ARRAY(SELECT * FROM UNNEST(
              ARRAY[listing -> 'cites_I', listing -> 'cites_II', listing -> 'cites_III']) s 
              WHERE s IS NOT NULL),
              '/'
            )
          ) AS listing
          FROM (
            SELECT taxon_concept_id, 
              ('cites_I' => CASE WHEN SUM(cites_I) > 0 THEN 'I' ELSE NULL END) ||
              ('cites_II' => CASE WHEN SUM(cites_II) > 0 THEN 'II' ELSE NULL END) ||
              ('cites_III' => CASE WHEN SUM(cites_III) > 0 THEN 'III' ELSE NULL END)
              AS listing
            FROM (
              SELECT taxon_concept_id, effective_at, species_listings.abbreviation, change_types.name AS change_type,
              CASE
                WHEN species_listings.abbreviation = 'I' AND change_types.name = 'ADDITION' THEN 1
                WHEN species_listings.abbreviation = 'I' AND change_types.name = 'DELETION' THEN -1
                ELSE 0
              END AS cites_I,
              CASE
                WHEN species_listings.abbreviation = 'II' AND change_types.name = 'ADDITION' THEN 1
                WHEN species_listings.abbreviation = 'II' AND change_types.name = 'DELETION' THEN -1
                ELSE 0
              END AS cites_II,
              CASE
                WHEN species_listings.abbreviation = 'III' AND change_types.name = 'ADDITION' THEN 1
                WHEN species_listings.abbreviation = 'III' AND change_types.name = 'DELETION' THEN -1
                ELSE 0
              END AS cites_III
              FROM listing_changes 
              LEFT JOIN species_listings ON species_listing_id = species_listings.id
              LEFT JOIN change_types ON change_type_id = change_types.id
              AND change_types.name IN ('ADDITION','DELETION')
              AND effective_at <= NOW()
            ) AS q
            GROUP BY taxon_concept_id
          ) AS qq
        ) AS qqq
        WHERE taxon_concepts.id = qqq.taxon_concept_id;
        END;
      $$;
    SQL
  end
end