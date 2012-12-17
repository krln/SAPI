class Admin::SpeciesListingsController < Admin::AdminController
  inherit_resources

  def index
    @designations = Designation.order(:name)
    index!
  end

  protected
    def collection
      @species_listings ||= end_of_association_chain.order('designation_id, name')
    end
end

