--
-- Name: rebuild_cites_show_flags(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE OR REPLACE FUNCTION rebuild_cites_show_flags() RETURNS void
    LANGUAGE plpgsql
    AS $$
        DECLARE
          cites_eu_id int;
        BEGIN
        SELECT id INTO cites_eu_id FROM taxonomies WHERE name = 'CITES_EU';

        -- set cites_show to true for all taxa except:
        -- implicitly listed subspecies
        UPDATE taxon_concepts SET listing = listing || 
        CASE
          WHEN (data->'rank_name' = 'SUBSPECIES'
          OR data->'rank_name' = 'ORDER'
	  OR data->'rank_name' = 'CLASS'
          OR data->'rank_name' = 'PHYLUM'
          OR data->'rank_name' = 'KINGDOM')
          AND listing->'cites_status' = 'LISTED'
          AND (listing->'cites_status_original')::BOOLEAN = FALSE
          THEN hstore('cites_show', 'f')
          WHEN listing->'cites_status' = 'EXCLUDED' OR (listing->'cites_status')::VARCHAR IS NULL
          THEN hstore('cites_show', 'f')
          ELSE hstore('cites_show', 't')
        END
        WHERE taxonomy_id = cites_eu_id;

        END;
      $$;


--
-- Name: FUNCTION rebuild_cites_show_flags(); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION rebuild_cites_show_flags() IS 'Procedure to rebuild the cites_show flag in taxon_concepts.listing.'
