CREATE OR REPLACE FUNCTION test_hello_world(
) RETURNS SETOF TEXT AS $$
  WITH geo_entity_type AS (
    INSERT INTO geo_entity_types (name, created_at, updated_at)
    VALUES ('COUNTRY', NOW(), NOW())
    RETURNING id
  )
  INSERT INTO geo_entities (name_en, iso_code2, geo_entity_type_id, created_at, updated_at)
  SELECT 'Poland', 'PL', geo_entity_type.id, NOW(), NOW()
  FROM geo_entity_type;
  SELECT is( iso_code2, 'PL', 'Should have iso code 2') FROM geo_entities;
$$ LANGUAGE sql;