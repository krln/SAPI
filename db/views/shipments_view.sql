DROP VIEW IF EXISTS trade_shipments_view;
-- TODO REMOVE
-- CREATE VIEW trade_shipments_view AS
--   SELECT
--     shipments.id,
--     year,
--     appendix,
--     taxon_concept_id,
--     full_name_with_spp(ranks.name, taxon_concepts.full_name) AS taxon,
--     reported_taxon_concept_id,
--     full_name_with_spp(reported_taxon_ranks.name, reported_taxon_concepts.full_name) AS reported_taxon,
--     importer_id,
--     importers.iso_code2 AS importer,
--     exporter_id,
--     exporters.iso_code2 AS exporter,
--     reported_by_exporter,
--     CASE
--       WHEN reported_by_exporter THEN 'E'
--       ELSE 'I'
--     END AS reporter_type,
--     country_of_origin_id,
--     countries_of_origin.iso_code2 AS country_of_origin,
--     CASE WHEN quantity = 0 THEN NULL ELSE quantity END,
--     unit_id,
--     units.code AS unit,
--     units.name_en AS unit_name_en,
--     units.name_es AS unit_name_es,
--     units.name_fr AS unit_name_fr,
--     term_id,
--     terms.code AS term,
--     terms.name_en AS term_name_en,
--     terms.name_es AS term_name_es,
--     terms.name_fr AS term_name_fr,
--     purpose_id,
--     purposes.code AS purpose,
--     source_id,
--     sources.code AS source,
--     import_permit_number,
--     export_permit_number,
--     origin_permit_number,
--     import_permits_ids,
--     export_permits_ids,
--     origin_permits_ids,
--     legacy_shipment_number,
--     uc.name AS created_by,
--     uu.name AS updated_by
--   FROM trade_shipments shipments
--   JOIN taxon_concepts
--     ON taxon_concept_id = taxon_concepts.id
--   JOIN ranks
--     ON ranks.id = taxon_concepts.rank_id
--   LEFT JOIN taxon_concepts reported_taxon_concepts
--     ON reported_taxon_concept_id = reported_taxon_concepts.id
--   JOIN ranks AS reported_taxon_ranks
--     ON reported_taxon_ranks.id = reported_taxon_concepts.rank_id
--   JOIN geo_entities importers
--     ON importers.id = importer_id
--   JOIN geo_entities exporters
--     ON exporters.id = exporter_id
--   LEFT JOIN geo_entities countries_of_origin
--     ON countries_of_origin.id = country_of_origin_id
--   LEFT JOIN trade_codes units
--     ON units.id = unit_id
--   JOIN trade_codes terms
--     ON terms.id = term_id
--   LEFT JOIN trade_codes purposes
--     ON purposes.id = purpose_id
--   LEFT JOIN trade_codes sources
--     ON sources.id = source_id
--   LEFT JOIN users as uc
--     ON shipments.created_by_id = uc.id
--   LEFT JOIN users as uu
--     ON shipments.updated_by_id = uu.id;
