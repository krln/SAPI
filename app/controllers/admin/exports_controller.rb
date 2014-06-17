class Admin::ExportsController < Admin::AdminController

  def index; end

  def download
    case params[:data_type]
      when 'Names'
        result = Species::TaxonConceptsNamesExport.new(params[:filters]).export
      when 'SynonymsAndTradeNames'
        result = Species::SynonymsAndTradeNamesExport.new(params[:filters]).export
      when 'CommonNames'
        result = Species::CommonNamesExport.new(params[:filters]).export
      when 'OrphanedTaxonConcepts'
        result = Species::OrphanedTaxonConceptsExport.new(params[:filters]).export
      when 'SpeciesReferenceOutput'
        result = Species::SpeciesReferenceOutputExport.new(params[:filters]).export
      when 'StandardReferenceOutput'
        result = Species::StandardReferenceOutputExport.new(params[:filters]).export
      when 'Distributions'
        result = Species::TaxonConceptsDistributionsExport.new(params[:filters]).export
      when 'IucnMappings'
        result = Species::IucnMappingsExport.new.export
      when 'CmsMappings'
        result = Species::CmsMappingsExport.new.export
    end
    if result.is_a?(Array)
      send_file Pathname.new(result[0]).realpath, result[1]
    else
      redirect_to admin_exports_path, :notice => "There are no #{params[:data_type]} to download."
    end
  end

end
