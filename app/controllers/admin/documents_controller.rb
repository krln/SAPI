# /admin/event/:event_id/documents
# /admin/documents
class Admin::DocumentsController < Admin::StandardAuthorizationController
  belongs_to :event, optional: true

  def index
    load_associations
    index! do
      if @event
        render 'admin/event_documents/index'
      else
        render 'index'
      end
      return
    end
  end

  def edit
    edit! do |format|
      load_associations
      @document.citations.build
      @taxonomy = Taxonomy.find_by_name(Taxonomy::CITES_EU)
      @geo_entities = GeoEntity.joins(:geo_entity_type).where(
        'geo_entity_types.name' => [GeoEntityType::COUNTRY, GeoEntityType::TERRITORY]
      )
      format.html { render 'new' }
    end
  end

  def update
    update! do |success, failure|
      success.html { success_redirect }
      failure.html { load_associations; render 'new' }
    end
  end

  def destroy
    destroy! do |success, failure|
      success.html { success_redirect }
      failure.html { failure_redirect }
    end
  end

  protected
  def collection
    @documents ||= end_of_association_chain.includes([:event, :language]).
      order(:date, :title).
      page(params[:page])
  end

  def load_associations
    @event_types = ['CitesCop', 'CitesAc', 'CitesPc', 'EcSrg']
    @events = Event.where(type: @event_types)
    @languages = Language.select([:id, :name_en, :name_es, :name_fr]).order(:name_en)
    @english = Language.find_by_iso_code1('EN')
  end

  def success_redirect
    url = if @event
      admin_event_documents_url(@event)
    else
      admin_documents_url
    end
    redirect_to url, :notice => 'Operation succeeded'
  end

  def failure_redirect
    url = if @event
      admin_event_documents_url(@event)
    else
      admin_documents_url
    end
    alert = if resource.errors.present?
      "Operation #{resource.errors.messages[:base].join(", ")}"
    else
      "Operation failed"
    end
    redirect_to url, :alert => alert
  end

end
