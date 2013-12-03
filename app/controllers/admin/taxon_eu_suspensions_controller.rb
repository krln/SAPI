class Admin::TaxonEuSuspensionsController < Admin::SimpleCrudController
  belongs_to :taxon_concept
  before_filter :load_lib_objects
  before_filter :load_search, :only => [:new, :index, :edit]

  layout 'taxon_concepts'

  def update
    update! do |success, failure|
      success.html {
        redirect_to admin_taxon_concept_eu_suspensions_url(params[:taxon_concept_id]),
        :notice => 'Operation successful'
      }
      failure.html {
        load_lib_objects
        load_search
        render 'new'
      }

      success.js { render 'create' }
      failure.js {
        load_lib_objects
        render 'new'
      }
    end
  end

  def create
    create! do |success, failure|
      success.html {
        redirect_to admin_taxon_concept_eu_suspensions_url(params[:taxon_concept_id]),
        :notice => 'Operation successful'
      }
      failure.html { 
        load_search
        render 'create'
      }
    end
  end

  protected

  def load_lib_objects
    @terms = Term.order(:code)
    @sources = Source.order(:code)
    @geo_entities = GeoEntity.order(:name_en).joins(:geo_entity_type).
      where(:is_current => true,
            :geo_entity_types => {:name => [GeoEntityType::COUNTRY,
                                            GeoEntityType::TERRITORY]})
    @eu_regulations = EuSuspensionRegulation.order("effective_at DESC")
    @eu_decision_types = EuDecisionType.suspensions
  end

  def collection
    @eu_suspensions ||= end_of_association_chain.
      joins(:geo_entity).
      order('is_current DESC, start_date DESC,
        geo_entities.name_en ASC').
      page(params[:page])
  end
end
