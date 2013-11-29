class Admin::ListingChangesController < Admin::SimpleCrudController
  before_filter :load_lib_objects, :only => [:new, :edit]
  belongs_to :eu_regulation

  def create
    create! do |success, failure|
      success.html {
        redirect_to admin_listing_changes_url,
        :notice => 'Operation successful'
      }
      failure.html {
        load_lib_objects
        render 'new'
      }
    end
  end

  def update
    update! do |success, failure|
      success.html {
        redirect_to admin_listing_changes_url,
        :notice => 'Operation successful'
      }
      failure.html {
        load_lib_objects
        render 'edit'
      }
    end
  end

  protected

  def load_lib_objects
    @units = Unit.order(:code)
    @terms = Term.order(:code)
    @sources = Source.order(:code)
    @purposes = Purpose.order(:code)
    @geo_entities = GeoEntity.order(:name_en).joins(:geo_entity_type).
      where(:is_current => true,
            :geo_entity_types => {:name => [GeoEntityType::COUNTRY,
                                            GeoEntityType::TERRITORY]})
    @suspension_notifications = CitesSuspensionNotification.
      select([:id, :name]).
      order('effective_at DESC')
  end

  def collection
    @listing_changes ||= end_of_association_chain.
      includes([
        :species_listing,
        :change_type,
        :party_geo_entity,
        :geo_entities,
        :annotation,
        :taxon_concept,
        :exclusions => [:geo_entities, :taxon_concept]
      ]).
      where("change_types.name <> '#{ChangeType::EXCEPTION}'").
      order('taxon_concepts.full_name ASC').
      page(params[:page]).per(200).where(:parent_id => nil)
  end
end
