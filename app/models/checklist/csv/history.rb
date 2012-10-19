class Checklist::Csv::History < Checklist::History
  include Checklist::Csv::Document
  include Checklist::Csv::HistoryContent

  def initialize(options={})
    super(options)
    @tmp_csv    = [Rails.root, "/tmp/", SecureRandom.hex(8), '.csv'].join
  end

  def columns
    res = super
    split = res.index(:party_name)
    res = res[0..split] + [:party_full_name] + res[split+1..res.length-1]
  end

  def column_values(rec)
    columns.map do |c|
      unless rec.respond_to? c
        send("column_value_for_#{c}", rec)
      else
        rec.send(c)
      end
    end
  end

  def column_value_for_party_full_name(rec)
    Checklist::CountryDictionary.instance.getNameById(rec.party_id)
  end

end
