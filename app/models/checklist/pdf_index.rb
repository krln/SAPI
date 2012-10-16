#Encoding: utf-8
class Checklist::PdfIndex < Checklist::PdfChecklist

  def initialize(options={})
    super(options.merge({:output_layout => :alphabetical}))
    @static_pdf = [Rails.root, "/public/static_index.pdf"].join
    @attachment_pdf = [Rails.root, "/public/CITES_abbreviations_and_annotations.pdf"].join
    @tmp_pdf    = [Rails.root, "/tmp/", SecureRandom.hex(8), '.pdf'].join
    @footnote_title_string = "CITES Species Index – <page>"
  end

  def prepare_queries
    super
    @animalia_query = Checklist::PdfIndexQuery.new(
      @animalia_rel,
      @common_names,
      @synonyms
    )
    @plantae_query = Checklist::PdfIndexQuery.new(
      @plantae_rel,
      @common_names,
      @synonyms
    )
  end

  def generate_pdf
    super do |pdf|
      Checklist::PdfIndexKingdom.new(pdf, @animalia_query, 'FAUNA').to_pdf
      Checklist::PdfIndexKingdom.new(pdf, @plantae_query, 'FLORA').to_pdf
    end
  end

end
