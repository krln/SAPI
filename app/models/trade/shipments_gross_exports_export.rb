# Implements "gross exports" shipments export
class Trade::ShipmentsGrossExportsExport < Trade::ShipmentsComptabExport
  include Trade::ShipmentReportQueries

  # for the serializer
  def full_csv_column_headers
    csv_column_headers + years
  end

private

  def query_sql
    headers = csv_column_headers
    select_columns = sql_columns.each_with_index.map do |c, i|
      "#{c} AS \"#{headers[i]}\""
    end + years_columns
    "SELECT #{select_columns.join(', ')} FROM (#{ct_subquery_sql}) ct_subquery"
  end

  def resource_name
    "gross_exports"
  end

  def outer_report_columns
    # reject subquery columns
    report_columns.delete_if { |column, properties| properties[:subquery] == true }
  end

  def sql_columns
    # locale will already be resolved
    outer_report_columns.map{ |column, properties| column }
  end

  def csv_column_headers
    outer_report_columns.map do |column, properties|
      I18n.t "csv.#{column}"
    end
  end

  def years
    (@filters[:time_range_start]..@filters[:time_range_end]).to_a
  end

  def years_columns
    years.map{ |y| "\"#{y}\"" }
  end

  def available_columns
    {
      :appendix => {},
      :taxon => {},
      :taxon_concept_id => {:internal => true},
      :term => {:en => :term_name_en, :es => :term_name_es, :fr => :term_name_fr},
      :unit => {:en => :unit_name_en, :es => :unit_name_es, :fr => :unit_name_fr},
      :country => {},
      :year => {:subquery => true},
      :gross_quantity => {:subquery => true}
    }
  end

  # extra columns returned by crosstab
  def crosstab_columns
    {
      :appendix => {:pg_type => 'TEXT'},
      :taxon_concept_id => {:pg_type => 'INT'},
      :taxon => {:pg_type => 'TEXT'},
      :term => {:pg_type => 'TEXT'},
      :unit  => {:pg_type => 'TEXT'},
      :country  => {:pg_type => 'TEXT'}
    }
  end

  # the query before pivoting
  def subquery_sql
    gross_exports_query
  end

  # pivots the quantity by year
  def ct_subquery_sql
    extra_crosstab_columns = crosstab_columns.keys
    extra_crosstab_columns &= report_columns.keys
    # the source query contains a viariable number of "extra" columns
    # ones needed in the output but not involved in pivoting
    source_sql = "SELECT ARRAY[appendix, taxon, term, unit, country],
      #{extra_crosstab_columns.join(', ')}, year, gross_quantity
      FROM (#{subquery_sql}) subquery
      ORDER BY 1, #{extra_crosstab_columns.length + 2}" #order by row_name and year
    source_sql = ActiveRecord::Base.send(:sanitize_sql_array, [source_sql, years])
    source_sql = ActiveRecord::Base.connection.quote_string(source_sql)
    # the categories query returns values by which to pivot (years)
    categories_sql = 'SELECT * FROM UNNEST(ARRAY[?])'
    categories_sql = ActiveRecord::Base.send(:sanitize_sql_array, [categories_sql, years.map(&:to_i)])
    year_columns = years_columns.map{ |y| "#{y} numeric"}.join(', ')
    # a set returning query requires that output columns are specified
    <<-SQL
      SELECT * FROM CROSSTAB('#{source_sql}', '#{categories_sql}')
      AS ct(
        row_name TEXT[],
        #{extra_crosstab_columns.map{ |c| "#{c} #{crosstab_columns[c][:pg_type]}"}.join(', ')},
        #{year_columns}
      )
    SQL
  end

end