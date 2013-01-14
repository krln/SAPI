#paste into rails console to get both generic + specific annotation for Cactaceae
tc = TaxonConcept.where("full_name = 'Cactaceae' AND data->'rank_name' = 'FAMILY'").first
lc = ListingChange.create(
  :taxon_concept_id => tc.id,
  :effective_at => '2010-06-23',
  :species_listing_id => SpeciesListing.find_by_abbreviation('II').id,
  :change_type_id => ChangeType.find_by_name('ADDITION')
)

lc_exc = ListingChange.create(
  :taxon_concept_id => TaxonConcept.where(:full_name => 'Pereskia').first.id,
  :parent_id => lc.id,
  :effective_at => '2010-06-23',
  :species_listing_id => SpeciesListing.find_by_abbreviation('II').id,
  :change_type_id => ChangeType.find_by_name('ADDITION')
)

english = Language.find_by_name('English')
spanish = Language.find_by_name('Spanish')
french = Language.find_by_name('French')

#update specific annotation to only include specific part with html
a = Annotation.create(
  :listing_change_id => lc.id
)
at = AnnotationTranslation.create(
  :annotation_id => a.id,
  :language_id => english.id,
  :full_note => "CACTACEAE spp.: Except the species included in Appendix I and except <i>Pereskia</i> spp., <i>Pereskiopsis</i> spp. and <i>Quiabentia</i> spp."
)

#add other translations of the specific annotation
AnnotationTranslation.create(
  :annotation_id => a.id,
  :language_id => spanish.id,
  :full_note =>"CACTACEAE spp.: Excepto especies incluidas en el Apéndice I y excepto <i>Pereskia</i> spp., <i>Pereskiopsis</i> spp. y <i>Quiabentia</i> spp."
)

AnnotationTranslation.create(
  :annotation_id => a.id,
  :language_id => french.id,
  :full_note =>"CACTACEAE spp.: Sauf espèces inscrites à l'Annexe I et excepto <i>Pereskia</i> spp., <i>Pereskiopsis</i> spp. et <i>Quiabentia</i> spp."
)

#add generic annotation with html
a = Annotation.create(:symbol => '#4', :parent_symbol => 'CoP15')
lc.annotation_id = a.id
lc.save
AnnotationTranslation.create(
  :annotation_id => a.id,
  :language_id => english.id,
  :full_note => <<-END
<p>All parts and derivatives, except:</p>
<ol>
<li>seeds, (including seedpods of Orchidaceae), spores and pollen (including pollinia). The exemption does
not apply to seeds from Cactaceae spp. exported from Mexico, and to seeds from <i>Beccariophoenix
madagascariensis</i> and <i>Neodypsis decaryi</i> exported from Madagascar;
<li>seedling or tissue cultures obtained <i>in vitro</i>, in solid or liquid media, transported in sterile containers;
<li>cut flowers of artificially propagated plants;
<li>fruits and parts and derivatives thereof, of naturalized or artificially propagated plants of the genus <i>Vanilla</i>
(Orchidaceae) and the family Cactaceae;
<li>stems, flowers, and parts and derivatives thereof of naturalized or artificially propagated plants of the
genera <i>Opuntia</i>, subgenus <i>Opuntia</i> and <i>Selenicereus</i> (Cactaceae); and
<li>finished products of <i>Euphorbia antisyphilitica</i> packaged and ready for retail trade.
</ol>
END
)
AnnotationTranslation.create(
  :annotation_id => a.id,
  :language_id => spanish.id,
  :full_note => <<-END
<p>Todas las partes y derivados, excepto:</p>
<ol>
<li>...;
<li>...;
<li>...;
</ol>
END
)
AnnotationTranslation.create(
  :annotation_id => a.id,
  :language_id => french.id,
  :full_note => <<-END
<p>Toutes les parties et tous les produits sauf:</p>
<ol>
<li>...;
<li>...;
<li>...;
</ol>
END
)