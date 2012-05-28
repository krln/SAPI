namespace :import do

  ## When I first tried to import the countries file I got an error related with character encoding
  ## I've then followed the instructions in this stackoverflow answer: http://stackoverflow.com/questions/4867272/invalid-byte-sequence-for-encoding-utf8
  ## So:
  ### 1- check current character encoding with: file path/to/file
  ### 2- change character encoding: iconv -f original_charset -t utf-8 originalfile > newfile
  desc 'Import countries from csv file [usage: FILE=[path/to/file] rake import:countries'
  task :countries => [:environment, "countries:copy_data"] do
    TMP_TABLE = 'countries_import'
    country_type = GeoEntityType.find_by_name('COUNTRY')
    puts "There are #{GeoEntity.count(conditions: {geo_entity_type_id: country_type.id})} countries in the database."
    sql = <<-SQL
      INSERT INTO geo_entities(name, iso_code2, iso_code3, geo_entity_type_id, legacy_id, legacy_type, created_at, updated_at)
      SELECT DISTINCT INITCAP(BTRIM(TMP.name)), INITCAP(BTRIM(TMP.iso2)), INITCAP(BTRIM(TMP.iso3)), #{country_type.id}, TMP.legacy_id, 'COUNTRY', current_date, current_date
      FROM #{TMP_TABLE} AS TMP
      WHERE NOT EXISTS (
        SELECT * FROM geo_entities
        WHERE legacy_id = TMP.legacy_id AND legacy_type = 'COUNTRY'
      );
    SQL
    ActiveRecord::Base.connection.execute(sql)
    puts "There are now #{GeoEntity.count(conditions: {geo_entity_type_id: country_type.id})} countries in the database"
    Rake::Task["import:countries:link_to_cites_regions"].invoke
  end

  namespace :countries do
    desc 'Creates countries_import table'
    task :create_table => :environment do
      TMP_TABLE = 'countries_import'
      begin
        puts "Creating tmp table: #{TMP_TABLE}"
        ActiveRecord::Base.connection.execute "CREATE TABLE #{TMP_TABLE} ( legacy_id integer, iso2 varchar, iso3 varchar, name varchar, long_name varchar, region_number varchar);"
        puts "Table created"
      rescue Exception => e
        puts "Tmp already exists removing data from tmp table before starting the import"
        ActiveRecord::Base.connection.execute "DELETE FROM #{TMP_TABLE};"
        puts "Data removed"
      end
    end
    desc 'Copy data into countries_import table'
    task :copy_data => :create_table do
      TMP_TABLE = 'countries_import'
      file = ENV["FILE"] || 'lib/assets/files/countries.csv'
      if !file || !File.file?(Rails.root+file) #if the file is not defined, explain and leave.
        puts "Please specify a valid csv file from which to import countries data"
        puts "Usage: FILE=[path/to/file] rake import:countries"
        next
      end
      puts "Copying data from #{file} into tmp table #{TMP_TABLE}"
      psql = <<-PSQL
\\COPY #{TMP_TABLE} ( legacy_id, iso2, iso3, name, long_name, region_number)
          FROM '#{Rails.root + file}'
          WITH DElIMITER ','
          CSV HEADER
      PSQL
      db_conf = YAML.load(File.open(Rails.root + "config/database.yml"))[Rails.env]
      system("export PGPASSWORD=#{db_conf["password"]} && psql -h #{db_conf["host"] || "localhost"} -U#{db_conf["username"]} -c \"#{psql}\" #{db_conf["database"]}")
      puts "Data copied to tmp table"
    end
    desc 'Removes countries_import table'
    task :remove_table => :environment do
      TMP_TABLE = 'countries_import'
      begin
        ActiveRecord::Base.connection.execute "DROP TABLE #{TMP_TABLE};"
        puts "Table removed"
      rescue Exception => e
        puts "Could not drop table #{TMP_TABLE}. It might not exist if this is the first time you are running this rake task."
      end
    end

    desc 'Link countries to the respective CITES Region'
    task :link_to_cites_regions => :environment do
      puts "Going to link countries to the respective CITES Region"
      sql = <<-SQL
        INSERT INTO geo_relationships(geo_entity_id, other_geo_entity_id, geo_relationship_type_id, created_at, updated_at)
        SELECT
          DISTINCT
          geo_entities.id,
          countries.id,
          geo_relationship_types.id,
          current_date,
          current_date
        FROM 
          public.countries_import,
          public.geo_entities,
          public.geo_entity_types,
          public.geo_relationship_types,
          public.geo_entities as countries
        WHERE
          geo_entity_types.id = geo_entities.geo_entity_type_id AND
          geo_entity_types."name" ilike 'CITES REGION' AND
          geo_entities."name" LIKE countries_import.region_number||'%' AND
          geo_relationship_types."name" ilike 'CONTAINS' AND
          countries.legacy_id = countries_import.legacy_id AND countries.legacy_type ilike 'COUNTRY' AND
          NOT EXISTS (
            SELECT *
            FROM geo_relationships
            WHERE geo_entity_id = geo_entities.id AND other_geo_entity_id = countries.id AND geo_relationship_type_id = geo_relationship_types.id
          );
      SQL
      puts "There are #{GeoRelationship.count} geo_relationships in the database."
      ActiveRecord::Base.connection.execute(sql)
      puts "There are now #{GeoRelationship.count} geo_relationships in the database."
    end
  end
end
