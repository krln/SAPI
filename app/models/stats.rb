class Stats

  include ActiveModel::Serializers::JSON

  def initialize (iso_code, kingdom)
    @iso_code = iso_code
    @kingdom = kingdom || 'Animalia'
    @geo_entity = GeoEntity.where(:iso_code2 => iso_code).first
    @species_classes = getSpeciesClasses
  end

  def getGeoEntity
    @geo_entity
  end

  def getKingdom
    @kingdom
  end

  def getSpeciesClasses
    MTaxonConcept.where(
      :rank_name => 'CLASS', :kingdom_name => @kingdom, :taxonomy_is_cites_eu => 'f').
      map do |s| s.class_name end
  end

  def species
    species_results = {}
    [:cites_eu, :cms].each do |taxonomy|
      species_results[taxonomy] = []
      @species_classes.each do |species_class|
        taxonomy_is_cites_eu = taxonomy == :cites_eu ? 't' : 'f'
        search = MTaxonConcept.where(
          "taxonomy_is_cites_eu = '#{taxonomy_is_cites_eu}'
          AND class_name = '#{species_class}'
          AND countries_ids_ary && ARRAY[#{@geo_entity.id}]")
        result = { 
          :name => species_class,
          :count => search.count
        }
        species_results[taxonomy] << result
      end
    end
    species_results
  end

  def trade
    trade_results = {}
    exports = Trade::Shipment.where(
      :importer_id => @geo_entity.id
    ).count
    trade_results['exports'] = exports
    imports = Trade::Shipment.where(
      :exporter_id => @geo_entity.id
    ).count
    trade_results['imports'] = imports
    trade_results
  end

end