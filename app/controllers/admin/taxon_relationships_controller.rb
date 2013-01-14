class Admin::TaxonRelationshipsController < Admin::SimpleCrudController
  inherit_resources
  belongs_to :taxon_concept
  before_filter :load_taxon_relationship_types, :only => [:index, :create]

  def index
    index! do
      @designations = Designation.order(:name).where('id <> ?', @taxon_concept.designation_id) #for Inter-designational relationships
      @inverse_taxon_relationships = TaxonRelationship.where(:other_taxon_concept_id => @taxon_concept.id).page(params[:page])
    end
  end

  def create
    @taxon_relationship = TaxonRelationship.new(params[:taxon_relationship])
    if @taxon_relationship.save
      @taxon_relationship.create_opposite if @taxon_relationship.is_bidirectional?
    end
    create!
  end

  protected

  def load_taxon_relationship_types
    @taxon_relationship_type = TaxonRelationshipType.find_by_name(
      params[:type] || TaxonRelationshipType::EQUAL_TO
    )
    @taxon_relationship_types = TaxonRelationshipType.order(:name).inter_designational
  end

  def collection
    @taxon_relationships ||= end_of_association_chain.
      joins(:taxon_relationship_type).
      where(:"taxon_relationship_types.name" => @taxon_relationship_type.name).
      page(params[:page])
  end

end
