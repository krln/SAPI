#Encoding: utf-8

namespace :import do

  desc "Import standard references records from csv file [usage: rake import:standard_references[path/to/file,path/to/another]"
  task :standard_references, 10.times.map { |i| "file_#{i}".to_sym } => [:environment] do |t, args|
    tmp_table = 'standard_references_import'
    puts "There are #{StandardReference.count} standard references in the database."
    files = files_from_args(t, args)
    files.each do |file|
      drop_table(tmp_table)
      create_import_table(tmp_table)
      copy_data_from_file(tmp_table, file)
      ActiveRecord::Base.connection.execute('DELETE FROM standard_references')
      ranks = {
        :kingdom => 'Kingdom',
        :phylum => 'Phylum',
        :class => 'Class',
        :order => 'TaxonOrder',
        :family => 'Family',
        :genus => 'Genus',
        :species => 'Species'
      }
      ranks.each do |k,v|
        sql = <<-SQL
          INSERT INTO standard_references (author, title, year,
            taxon_concept_name, taxon_concept_rank, position,
            created_at, updated_at)
          SELECT author, title, "year",
            UNNEST(STRING_TO_ARRAY(#{v},';')) AS taxon_concept_name,
            '#{k.to_s.upcase}' AS taxon_concept_rank, row_number() OVER(),
            current_date, current_date
          FROM #{tmp_table}
        SQL
        ActiveRecord::Base.connection.execute(sql)
      end
      #insert the ones without taxon concept mapping
      sql = <<-SQL
        INSERT INTO standard_references (author, title, year,
          created_at, updated_at)
        SELECT author, title, "year",
          current_date, current_date
        FROM #{tmp_table}
        WHERE #{ranks.values.map{ |r| "#{r} IS NULL" }.join(' AND ')}
      SQL
      ActiveRecord::Base.connection.execute(sql)
      #update the taxon_concept_id and species_legacy_id
      sql = <<-SQL
        UPDATE standard_references
        SET taxon_concept_id = q.id, species_legacy_id = q.legacy_id
        FROM (
        SELECT taxon_concept_name, taxon_concepts.id, taxon_concepts.legacy_id
        FROM standard_references
        INNER JOIN taxon_concepts
        ON taxon_concept_name = taxon_concepts.data->'full_name'
        ) q WHERE q.taxon_concept_name = standard_references.taxon_concept_name
      SQL
      ActiveRecord::Base.connection.execute(sql)
      #update the reference_id and reference_legacy_id
      sql = <<-SQL
      UPDATE standard_references
      SET reference_id = qqq.reference_id, reference_legacy_id = qqq.reference_legacy_id
      FROM (
        SELECT DISTINCT q.id AS reference_id, q.legacy_id AS reference_legacy_id, qq.id AS standard_reference_id
        FROM
        (         
          SELECT id,
          (REGEXP_SPLIT_TO_ARRAY("standard_references".author,'[\s,.]')::VARCHAR[])[1] AS author_match,
          SUBSTR(REGEXP_REPLACE(LOWER("standard_references".title),'[ .,:;_]','','g'), 0, 50) AS title_match
          FROM standard_references
        ) qq 
        INNER JOIN
        (
          SELECT id, legacy_id,
          (REGEXP_SPLIT_TO_ARRAY("references".author,'[\s,.]')::VARCHAR[])[1] AS author_match,
          SUBSTR(REGEXP_REPLACE(LOWER("references".title),'[ .,:;_]','','g'), 0, 50) AS title_match
          FROM "references"
        ) q   
        ON q.title_match = qq.title_match AND q.author_match = qq.author_match
      ) qqq
      WHERE qqq.standard_reference_id = standard_references.id
      SQL
      ActiveRecord::Base.connection.execute(sql)
    end
    puts "There are now #{StandardReference.count} standard references in the database"
  end

end