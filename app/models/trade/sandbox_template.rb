# == Schema Information
#
# Table name: trade_sandbox_template
#
#  appendix          :string(255)
#  species_name      :string(255)
#  term_code         :string(255)
#  quantity          :string(255)
#  unit_code         :string(255)
#  trading_partner   :string(255)
#  country_of_origin :string(255)
#  export_permit     :string(255)
#  origin_permit     :string(255)
#  purpose_code      :string(255)
#  source_code       :string(255)
#  year              :string(255)
#  import_permit     :string(255)
#  id                :integer          not null, primary key
#

class Trade::SandboxTemplate < ActiveRecord::Base
  self.table_name = :trade_sandbox_template

  COLUMNS_IN_CSV_ORDER = [
    "appendix", "species_name", "term_code", "quantity", "unit_code",
    "trading_partner", "country_of_origin", "import_permit", "export_permit",
    "origin_permit", "purpose_code", "source_code", "year"
  ]
  IMPORTER_COLUMNS = COLUMNS_IN_CSV_ORDER
  EXPORTER_COLUMNS = COLUMNS_IN_CSV_ORDER - ['import_permit']

  # Dynamically define AR class for table_name
  # (unless one exists already)
  def self.ar_klass(table_name)
    klass_name = table_name.camelize
    begin
      "Trade::#{klass_name}".constantize
    rescue NameError
      klass = Class.new(ActiveRecord::Base) do
        self.table_name = table_name
        include ActiveModel::ForbiddenAttributesProtection
        attr_accessible :appendix,
          :species_name,
          :term_code,
          :quantity,
          :unit_code,
          :trading_partner,
          :country_of_origin,
          :import_permit,
          :export_permit,
          :origin_permit,
          :purpose_code,
          :source_code,
          :year
      end
      Trade.const_set(klass_name, klass)
    end
  end

  private
  def self.create_stmt(target_table_name)
    sql = <<-SQL
      CREATE TABLE #{target_table_name} (PRIMARY KEY(id))
      INHERITS (#{table_name})
    SQL
  end

  def self.drop_stmt(target_table_name)
    sql = <<-SQL
      DROP TABLE #{target_table_name}
    SQL
  end

  def self.copy_stmt(target_table_name, csv_file_path, columns_in_csv_order)
    sql = <<-PSQL
      \\COPY #{target_table_name} (#{columns_in_csv_order.join(', ')})
      FROM ?
      WITH DELIMITER ','
      ENCODING 'utf-8'
      CSV HEADER;
    PSQL
    sanitize_sql_array([sql, csv_file_path])
  end

  def self.duplicate_column_stmt target_table_name, origin_col, destiny_col, data_type="varchar"
    sql = <<-SQL
      UPDATE #{target_table_name}
      SET #{destiny_col} = #{origin_col};
    SQL
  end
end
