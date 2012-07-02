--
-- Name: fix_cites_listing_changes(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE OR REPLACE FUNCTION fix_cites_listing_changes() RETURNS void
    LANGUAGE plpgsql
    AS $$
      BEGIN
      INSERT INTO listing_changes 
      (taxon_concept_id, species_listing_id, change_type_id, effective_at, created_at, updated_at)
      SELECT 
      qq.taxon_concept_id, qq.species_listing_id, (SELECT id FROM change_types WHERE name = 'DELETION' LIMIT 1),
      qq.effective_at - time '00:00:01', NOW(), NOW()
      FROM (
                    WITH q AS (
                             SELECT taxon_concept_id, species_listing_id, change_type_id,
                             effective_at, change_types.name AS change_type_name,
                             species_listings.abbreviation AS listing_name,
                             listing_distributions.geo_entity_id AS party_id,
                             ROW_NUMBER() OVER(ORDER BY taxon_concept_id, effective_at) AS row_no
                             FROM
                             listing_changes
                             LEFT JOIN change_types on change_type_id = change_types.id
                             LEFT JOIN species_listings on species_listing_id = species_listings.id
                             LEFT JOIN designations ON designations.id = species_listings.designation_id
                             LEFT JOIN listing_distributions ON listing_changes.id = listing_distributions.listing_change_id AND listing_distributions.is_party = 't'
                             WHERE change_types.name IN ('ADDITION','DELETION')
                             AND designations.name = 'CITES'
                     )
                     SELECT q1.taxon_concept_id, q1.species_listing_id, q2.effective_at
                     FROM q q1 LEFT JOIN q q2 ON (q1.taxon_concept_id = q2.taxon_concept_id AND q2.row_no = q1.row_no + 1)
                     WHERE q2.taxon_concept_id IS NOT NULL
                     AND q1.change_type_id = q2.change_type_id AND q1.change_type_name = 'ADDITION'
                     AND NOT (q1.listing_name = 'III' AND q2.listing_name = 'III' AND q1.party_id <> q2.party_id)
      ) qq;
      END;
      $$;


--
-- Name: FUNCTION fix_cites_listing_changes(); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION fix_cites_listing_changes() IS 'Procedure to insert deletions between any two additions to appendices for a given taxon_concept.';
