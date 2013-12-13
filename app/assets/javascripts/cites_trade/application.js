$(document).ready(function(){

  var ajaxFail, initExpctyImpcty, initTerms, initSources, initPurposes,
    countries = {}, units = {}, terms = {}, purposes = {}, sources = {},
    selected_taxa = '',
    is_search_page = $('#form_expert').length > 0,
    is_download_page = $('#net_gross_options').length > 0;
    is_view_results_page = $('#query_results_table').length > 0;

  ajaxFail = function (xhr, ajaxOptions, thrownError) {
  	//console.log(xhr, ajaxOptions, thrownError);
    growlMe("The request failed.");
  };

  // Your code here
  $(".tipify").tipTip();

  $('.show_search').qtip({
     content: {
  	   text: 'If there any problems, contact blah-blah',
  	   title: {
                    text: 'Please make your selection in the tabs on the left',
                    button: true
                 }
  	},
     position: {
        my: 'top left', at: 'bottom left'
     },
     show: {
         event: false, // Don't specify a show event...
         ready: true // ... but show the tooltip when ready
      },
      hide: false, // Don't specify a hide event either!
      style: {
         classes: 'ui-tooltip-shadow ui-tooltip-jtools' 
      }
  })

  function growlMe(text){
  	$.jGrowl(text);
  };
  
  function growlMeSticky(text){
  	$.jGrowl(text, {sticky: true});
  };
  
  function notyNormal(message){
  	noty({layout: 'topRight', text: message, timeout: 4000});
  };
  
  function notySticky(message){
  	noty({ layout: 'top',
   			   type: 'information',
   			   closeWith: ['button'],
    			 text: message,
           timeout: 1000
    });
  };

  //Accordion
  $( "#accordion_expert" ).accordion(
		{
			event : 'mouseover',
			autoHeight: false
		}								  
	);
   
  //setting the tabs for the search
  $("#tabs").tabs().addClass('ui-tabs-vertical ui-helper-clearfix');
  //enabling the tabs to be visible again
  $("#tabs").css("display", "block");
	$("#tabs li").removeClass('ui-corner-top').addClass('ui-corner-left');
 
  $(".someClass").tipTip({maxWidth: "300px"});
  //using the qtip2 plugin
  $(".qtipify").qtip(
	{				
		style: {
      classes: 'ui-tooltip-green ui-tooltip-cluetip'
   	}				
	});
 
  $("#genus_all_id").val('').trigger("liszt:updated");
  $("#genus_all_id").chosen({
  	allow_single_deselect:true,
  	no_results_text: "No results matched"
  }).change(function(){
  	var my_value = $(this).val();
  	$('#species_out').text(my_value);
  });

  $('#taxon_search').width(300);
 
  function initialiseControls() {
	  $('input[name="selection_taxon"]').filter('[value="taxon"]')
      .attr('checked', true);
	  $('#div_genus').find('button').addClass('ui-state-disabled')
      .removeClass('ui-state-enabled');
	  $('#genus_all_id_chzn').removeClass('chzn-container-active')
      .addClass('chzn-disabled');
	  $('#div_genus :input').attr('disabled', true);
	  //prevent form support on input and select enter
	  $('input,select').keypress(function(event) { return event.keyCode != 13; });
  };

  var raw_headers = [
      'id', 'year', 'appendix', 'taxon',  'term', 'quantity', 'unit',  
      'importer', 'exporter', 'origin', 'purpose', 'source', 'reporter_type', 
      'imp_permit', 'exp_permit', 'origin_permit' ],
    raw_fields = ['id', 'year', 'appendix', 'taxon',  'term', 'quantity', 'unit',  
      'importer', 'exporter', 'origin', 'purpose', 'source', 'reporter_type', 
      'import_permit_number', 'export_permit_number', 
      'country_of_origin_permit_number' ],
    comptab_headers = ['Year', 'Appendix', 'Family', 'Taxon', 'Importer', 'Exporter',
      'origin',  'Importer-reported quantity', 'Exporter-reported quantity', 'Term', 'Unit',  
      'Purpose', 'Source'],
    comptab_fields = ['year', 'appendix', 'family', 'taxon', 'importer', 'exporter',
      'origin',  'importer_quantity', 'exporter_quantity', 'term', 'unit',  
      'purpose', 'source'];

  function formatDataRow (data_row, data_type) {
    var fields;
    if (data_type === 'raw') {
      fields = raw_fields;
    } else if (data_type === 'comptab') {
      fields = comptab_fields;
    }
    return _.map(fields, function (field) {
      if (field === 'importer') {
        if (countries[data_row.importer_id]) {
          return countries[data_row.importer_id].iso_code2;
        } else {
          return '';
        }
      } else if (field === 'exporter') {
        if (countries[data_row.exporter_id]) {
          return countries[data_row.exporter_id].iso_code2;
        } else {
          return '';
        }
      } else if (field === 'origin') {
        if (countries[data_row.country_of_origin_id]) {
          return countries[data_row.country_of_origin_id].iso_code2;
        } else {
          return '';
        }
      } else if (field === 'unit') {
        if (units[data_row.unit_id]) {
          return units[data_row.unit_id].code;
        } else {
          return '';
        }
      } else if (field === 'taxon') {
        if (data_row.taxon_concept) {
          return data_row.taxon_concept.full_name;
        } else if (data_row.taxon) {
          return data_row.taxon
        } else {
          return '';
        }
      } else if (field === 'term') {
        if (terms[data_row.term_id]) {
          return terms[data_row.term_id].code;
        } else {
          return '';
        }
      } else if (field === 'purpose') {
        if (purposes[data_row.purpose_id]) {
          return purposes[data_row.purpose_id].code;
        } else {
          return '';
        }
      } else if (field === 'source') {
        if (sources[data_row.source_id]) {
          return sources[data_row.source_id].code;
        } else {
          return '';
        }
      } else if (data_row[field]) {
        return data_row[field];
      } else {
        return '';
      }
    });
  }

  function buildHeader (data, data_type) {
    var header = 
      "<thead><tr><% _.each(res, function(head) { %> <td><%=head %></td> <% }); %></tr></thead>",
      headers;
    if (data_type === 'raw') {
      headers = raw_headers;
    } else if (data_type === 'comptab') {
      headers = comptab_headers;
    }
    return _.template(header, {res: headers});
  }

  function buildRows (data, data_type) {
    var t = "";
    _.each(data, function(data_row) {
      var row = 
        "<tr><% _.each(res, function(value) { %> <td>" + 
        "<%= (value && value.full_name) ? value.full_name : value %>" +
        "</td> <% }); %></tr>";
      t += _.template(row, { res: formatDataRow(data_row, data_type) });
    });
    return t;
  }
  
  function fixTaxonId (arr) {
    return _.map(arr, function (obj) {
      if (obj.name === 'taxon_concepts_ids[]') {
        return {name: 'taxon_concepts_ids[]', value: selected_taxa};
      } else {
        return obj;
      }
    });
  }
  

  function parseInputs ($inputs) {
    var values = {};
    $inputs.each(function() {
      var name = this.name.replace('[]', '');
      if (name !== "" && name !== void 0 && name !== null) {
        if (name === 'taxon_concepts_ids') {
          values[name] = [selected_taxa];
        } else {
          values[name] = $(this).val();
        }
      }
    });
    values['report_type'] = 'raw';
    return values;
  }
  
  function queryResults () {
    var href, inputs, values, params, $link;
    if (queryResults.ajax) {
      href = '/trade/exports/download.json';
      values = parseInputs($('#form_expert :input'));
      params = $.param({'filters': values});
      $.ajax({
        url: href,
        dataType: 'json',
        data: params,
        type: 'GET'
      }).then( function (res) {
        if (res.total > 0) {
          // There is something to download!
          queryResults.ajax = false;
          queryResults.call(this);
        } else {
          $('#search-error-message').show();
        }
      }, ajaxFail);
    } else {
      $link = $(this);
      values = parseInputs($('#form_expert :input'));
      params = $.param({'filters': values});
      href = '/' + locale + '/cites_trade/download?' + params;
      queryResults.ajax = true;
      $('#search-error-message').hide();
      $link.attr('href', href).click();
      window.location.href = $link.attr("href");
    }
  }
  queryResults.ajax = true;
  $("#submit_expert").click(function(e) {
    queryResults.call(this);
  });


  //function to reset all the countrols on the expert_accord page
  function resetSelects() {
 	  $('#qryFrom').find('option:first').attr('selected', 'selected')
      .trigger('change');
 	  $('#qryTo').find('option:first').attr('selected', 'selected')
      .trigger('change');
 	  $('#taxon_search').val('');
 	  $('#genus_search').val('');
 	  $('#species_out').text('');
 	  $('#sources').select2("val","all_sou");
 	  $('#purposes').select2("val","all_pur");
 	  $('#terms').select2("val","all_ter");
 	  $('#expcty').select2("val","all_exp");
 	  $('#impcty').select2("val","all_imp");	
     notySticky('Values are being reset...');
  };

  $('#reset_search').click(function() {
  	resetSelects();
  	show_values_selection();
    // Removing the table results on reset
    $("#query_results_table").find('thead,tbody').remove();
    $('#query_results').find('p.info').text('');
    // and resetting globals...
    selected_taxa = '';
  	return false;
  });
 
  //Radio selector for genus or taxon search
  $("input[name='selection_taxon']").on('change',function(){
	  var myValue = $(this).val();
	  if (myValue == 'genus') {
	  	$('#div_taxon').find('input').addClass('ui-state-disabled')
        .removeClass('ui-state-enabled');
	  	$('#div_genus').find('button').removeClass('ui-state-disabled')
        .addClass('ui-state-enabled');
	  	$('#div_taxon :input').attr('disabled', true);
	  	$('#div_genus :input').removeAttr('disabled');
	  	$('#taxon_search').val('');
	  	$('#species_out').text('');
	  } else if (myValue == "taxon") {
	  	$('#div_genus').find('button').addClass('ui-state-disabled')
        .removeClass('ui-state-enabled');
	  	$('#div_taxon').find('input').removeClass('ui-state-disabled')
        .addClass('ui-state-enabled');
	  	$('#div_taxon :input').removeAttr('disabled');
	  	$('#div_genus :input').attr('disabled', true);
      $('#genus_search').val('');
	  	$('#species_out').text('');
	  }
  });

  $('#table_selection').colorize({
  		altColor: '#E6EDD7',
  		bgColor: '#E6EDD7',
  		hoverColor: '#D2EF9A'
  });
   
  
  function getSelectionTextNew(source) {
  	var values = [];
  
  	$('#ms-' + source).find('div.ms-selection ul.ms-list  li').each(function() {
      values.push($(this).text());
    });
  
  	return values.join(',')
  } 

  function getSelectionText(source) {
  	myValues = new Array();
  	$('#' + source + ' option:selected').each(function(index, value) {
  		myValues.push($(value).text());
    });
  	return myValues.toString();
  }
  
  initUnitsObj = function (data) {
    _.each(data.units, function (unit) {
      units[unit.id] = unit;
    });
    unLock('initUnitsObj');
  }
  
  initCountriesObj = function (data) {
    _.each(data.geo_entities, function (country) {
      countries[country.id] = country;
    });
    unLock('initCountriesObj');
  }
  
  initTermsObj = function (data) {
    _.each(data.terms, function (term) {
      terms[term.id] = term;
    });
    unLock('initTermsObj');
  }
  
  initPurposesObj = function (data) {
    _.each(data.purposes, function (purpose) {
      purposes[purpose.id] = purpose;
    });
    unLock('initPurposesObj');
  }

  initSourcesObj = function (data) {
    _.each(data.sources, function (source) {
      sources[source.id] = source;
    });
    unLock('initSourcesObj');
  }

  initExpctyImpcty = function (data) {
  	var args = {
  	  	data: data.geo_entities,
  	  	condition: function (item) {return item.iso_code2},
  	  	text: function (item) {return item.name}
  	  };
  
    initCountriesObj(data);
  	populateSelect(_.extend(args, {
  		selection: $('#expcty'),
  		value: function (item) {return item.id}
  	}));
    allOptionsDictionary["all_exp"] = true;
    $('#expcty').select2({
    	width: '75%',
    	allowClear: false,
    	closeOnSelect: false
    }).on('change', function(e){
    	var selection = "";
    	if (e.val.length == 0) {
    		$(this).select2("val","all_exp");
        allOptionsDictionary["all_exp"] = true;
      }
    	var prop = $(this).select2('data');
    	selection = getText(prop);
    	if (e.val.length > 1) {
    		var new_array = [];
    		new_array = checkforAllOptions(prop,'all_exp');
    		$(this).select2('data', new_array);
    		selection = getText(new_array);
    	}
    	$('#expcty_out').text(selection);
    });
  
    populateSelect(_.extend(args, {
  		selection: $('#impcty'),
  		value: function (item) {return item.id}
  	}));
    allOptionsDictionary["all_imp"] = true;
    $('#impcty').select2({
    	width: '75%',
    	allowClear: false,
    	closeOnSelect: false
    }).on('change', function(e){
    	selection = "";
    	if (e.val.length == 0) {
    		$(this).select2("val","all_imp");
        allOptionsDictionary["all_imp"] = true;
    	}
    	prop = $(this).select2('data');
    	selection = getText(prop);
    	if (e.val.length > 1)
    	{
    		new_array = new Array();
    		new_array = checkforAllOptions(prop,'all_imp');
    		$(this).select2('data', new_array);
    		selection = getText(new_array);
    	}
    	$('#impcty_out').text(selection);
    });
  };
  
  initTerms = function (data) {
  	var selection = $('#terms'),
  	  args = {
  	  	selection: selection,
  	  	data: data.terms,
  	  	condition: function (item) {return item.code},
  	  	value: function (item) {return item.id},
  	  	text: function (item) {return item.code + ' - ' + item.name}
  	  },
      alloption = 'all_ter';
    allOptionsDictionary[alloption] = true;
    initTermsObj(data);
  	populateSelect(args);
    selection.select2({
    	width: '75%',
    	allowClear: false,
    	closeOnSelect: false
    }).on('change', function(e){
    	// growlMe($(this).attr('id'));
    	selection = "";
    	if (e.val.length == 0) {
    		// growlMe('You need to make at least one selection! - ' + e.val);
    		$(this).select2("val", alloption);
        allOptionsDictionary[alloption] = true;
    	}
    	prop = $(this).select2('data');
    	selection = getText(prop);
    	if (e.val.length > 1)
    	{
    		new_array = new Array();
    		new_array = checkforAllOptions(prop, alloption);
    		$(this).select2('data', new_array);
    		selection = getText(new_array);
    	}
    	$('#terms_out').text(selection);
    });
  }

  initSources = function (data) {
  	var selection = $('#sources'),
  	  args = {
  	  	selection: selection,
  	  	data: data.sources,
  	  	condition: function (item) {return item.code},
  	  	value: function (item) {return item.id},
  	  	text: function (item) {return item.code + ' - ' + item.name}
  	  },
      alloption = 'all_sou';
  	allOptionsDictionary[alloption] = true;
    initSourcesObj(data);
  	populateSelect(args);
    selection.select2({
    	width: '75%',
    	allowClear: false,
    	closeOnSelect: false
    }).on('change', function(e){
    	// growlMe($(this).attr('id'));
    	selection = "";
    	if (e.val.length == 0) {
    		$(this).select2("val", alloption);
        allOptionsDictionary[alloption] = true;
    	}
    	prop = $(this).select2('data');
    	selection = getText(prop);
    	if (e.val.length > 1)
    	{
    		new_array = new Array();
    		new_array = checkforAllOptions(prop, alloption);
    		$(this).select2('data', new_array);
    		selection = getText(new_array);
    	}
    	$('#sources_out').text(selection);
    });
  };
  
  initPurposes = function (data) {
  	var selection = $('#purposes'),
  	  args = {
  	  	selection: selection,
  	  	data: data.purposes,
  	  	condition: function (item) {return item.code},
  	  	value: function (item) {return item.id},
  	  	text: function (item) {return item.code + ' - ' + item.name}
  	  },
      alloption = 'all_pur';
  	allOptionsDictionary[alloption] = true;
    initPurposesObj(data);
  	populateSelect(args); 
    selection.select2({
    	width: '75%',
    	allowClear: false,
    	closeOnSelect: false
    }).on('change', function(e){
    	selection = "";
    	if (e.val.length == 0) {
    		$(this).select2("val", alloption);
        allOptionsDictionary[alloption] = true;
    	}
    	prop = $(this).select2('data');
    	selection = getText(prop);
    	if (e.val.length > 1) {
    		new_array = new Array();
    		new_array = checkforAllOptions(prop, alloption);
    		$(this).select2('data', new_array);
    		selection = getText(new_array);
    	}
    	$('#purposes_out').text(selection);
    });
  };

  var allOptionsDictionary = {};
  //function to check if all countries is in the list
  function checkforAllOptions(source, alloption) {
  	var myValues = [];
  	for (var i=0; i < source.length; i++) {
  		if (source[i].id == alloption && allOptionsDictionary[alloption]) {
        // Removing alloption
  			source.splice(i,1);
        allOptionsDictionary[alloption] = true;
  			break;
  		} else if (source[i].id == alloption && !allOptionsDictionary[alloption]) {
        source = source.splice(i,1);
        allOptionsDictionary[alloption] = false;
        break;
      }
  	}
  	return source;
  }

  //retrieve the text for display
  function getText(source)
  {
  	myValues = new Array();
  	for(var i=0;i < source.length;i++)
  	{
  		myValues.push(source[i].text);
  	}
  	return myValues.toString();
  }
  
  function show_values_selection() {
  	var year_from = $('#qryFrom').val();
  	var year_to = $('#qryTo').val();
  	var exp_cty = $('#expctyms2side__dx').text();
  	var imp_cty = $('#impctyms2side__dx').text();
  	var sources = $('#sourcesms2side__dx').text(); 
  	var purposes = $('#purposesms2side__dx').text();
  	var terms = $('#termsms2side__dx').text();
  	
  	$('#year_from > span').text(year_from);
    $('#year_to > span').text(year_to);
  	$('#expcty_out').text(getSelectionText('expcty'));
  	$('#impcty_out').text(getSelectionText('impcty'));
  	$('#sources_out').text(getSelectionText('sources'));
  	$('#purposes_out').text(getSelectionText('purposes'));
  	$('#terms_out').text(getSelectionText('terms'));		
  	$('#genus_all_id').val();				  
  };

  $('#side .ui-button, #form .ui-button').hover(function() {
  	$(this).toggleClass('ui-state-hover');
  });

  function getFormattedSynonyms (d) {
    if (d.synonyms.length > 0 ) {
      return ' (' + d.synonyms.join(', ') + ')';
    }
    return '';
  }

  function getTaxonLabel (element, term) {
    var name = element.full_name,
      term = term.replace(/[\-\[\]{}()*+?.,\\\^$|#\s]/g, "\\$&"),
      suggestion = element.full_name + getFormattedSynonyms(element),
      transform = function (match) {
        return "<span class='match'>" + match + "</span>";
      };
    return suggestion.replace(new RegExp("(" + term + ")", "gi"), transform);
  }
  
  function parseTaxonData (data, term) {
    var d = data.auto_complete_taxon_concepts;
  	return _.map(d, function (element, index) {
  	  return {
        'value': element.id, 
        'label': element.full_name + getFormattedSynonyms(element),
        'drop_label': getTaxonLabel(element, term)
      };
  	});
  }
   
  //Autocomplete for cites_names
  if (is_search_page) {
    $("#taxon_search").autocomplete({
    	source: function(request, response) {
        var term = request.term;
        $.ajax({
          url: "/api/v1/auto_complete_taxon_concepts",
          dataType: "json",
          data: {
            taxonomy: 'CITES',
            taxon_concept_query: term,
            autocomplete: true,
            'ranks[]': "SPECIES"
          },
          success: function(data) {
            response(parseTaxonData(data, term));
          },
    			error : function(xhr, ajaxOptions, thrownError){
    				growlMe(xhr.status + " ====== " + thrownError);
    			}
        });
      },
    	select: function( event, ui ) {
    		$(this).attr('value', ui.item.label);
        selected_taxa = ui.item.value;
    		$('#species_out').text(ui.item.label);
    		return false;
    	}
    }).data( "ui-autocomplete" )._renderItem = function( ul, item ) {
      return $( "<li>" )
        .append( "<a>" + item.drop_label + "</a>" )
        .appendTo( ul );
      };
  }

  //Autocomplete for cites_genus
  $("#genus_search").autocomplete({
  	source: function(request, response) {
      $.ajax({
        url: "/api/v1/auto_complete_taxon_concepts",
        dataType: "json",
        data: {
          taxonomy: 'CITES',
          taxon_concept_query: request.term,
          autocomplete: true,
          'ranks[]': 'GENUS'
        },
        success: function(data) {
          response(parseTaxonData(data));
        },
  			error : function(xhr, ajaxOptions, thrownError){
  				growlMe(xhr.status + " ====== " + thrownError);
  			}
      });
    },
  	select: function( event, ui ) {
  		$(this).val(ui.item.label);
      selected_taxa = ui.item.value;
  		$('#species_out').text(ui.item.label);	
  		return false;
  	}
  });

  show_values_selection();

  $('#qryFrom, #qryTo').on('change',function() {
  	var y_from = $('#qryFrom').val();
  	var y_to = $('#qryTo').val();
    $('#year_from > span').text(y_from);
    $('#year_to > span').text(y_to);
  });

  //Put functions to be executed here
  initialiseControls();
  
  function populateSelect(args) {
  	var data = args.data,
  	  selection = args.selection,
  	  condition = args.condition,
  	  value = args.value,
  	  text = args.text;
  	_.each(data, function (item) {
	  	if (condition(item)) {
	      selection.append('<option title="' + text(item)
	      	+ '" value="' + value(item) + '">' + text(item) + '</option>');
	    } 
    });
  }

  var data_type = {dataType: 'json'};

  // This is used for checking on which page we are, because we only need this
  // stuff on the query page, not on the download one.

  if (is_search_page || is_view_results_page) {
    $.when($.ajax("/api/v1/units?locale=" + locale, data_type)).then(initUnitsObj, ajaxFail);
    $.when($.ajax("/api/v1/geo_entities?geo_entity_types[]=COUNTRY&geo_entity_types[]=TERRITORY&locale=" + locale, data_type)).then(initExpctyImpcty, ajaxFail);
    $.when($.ajax("/api/v1/terms?locale=" + locale, data_type)).then(initTerms, ajaxFail);
    $.when($.ajax("/api/v1/sources?locale=" + locale, data_type)).then(initSources, ajaxFail);
    $.when($.ajax("/api/v1/purposes?locale=" + locale, data_type)).then(initPurposes, ajaxFail);
  }

  //////////////////////////
  // Download page specific:

  function displayResults (q) {
    var formURL = '/trade/shipments',
      data_rows, table_tmpl;
    $.ajax(
      {
        url : formURL,
        type: "GET",
        data : q,
        success: function(data, textStatus, jqXHR) {
          if ( q.indexOf('[report_type]=comptab') !== -1 ) {
            data_rows = data.search.shipments_rel;
            table_tmpl = buildHeader(data_rows[0], 'comptab') + buildRows(data_rows, 'comptab');
          } else {
            if (data.meta.total === 0) {
              $('#search-error-message').show();
              $("#query_results_table").find('thead,tbody').remove();
            } else {
              data_rows = data.shipments;
              table_tmpl = buildHeader(data_rows[0], 'raw') + buildRows(data_rows, 'raw');
              $('#search-error-message').hide();
              
              $('#query_results .info').text(
                'Showing ' + data.shipments.length + ' rows of ' + data.meta.total
              );
            }
          }
          $('#query_results_table').html(table_tmpl);
        },
        error: ajaxFail
    });
  }

  function goToResults (q) {
    var $link = $('#view_genie'),
     href = '/' + locale + '/cites_trade/download/view_results?' + q;
    $link.attr('href', href).click();
    window.location.href = $link.attr("href");
  }

  function downloadResults (q) {
    var $link = $('#download_genie'),
      href = '/trade/exports/download?' + q;
    $link.attr('href', href).click();
    window.location.href = $link.attr("href");
  }
  
  function handleDownloadRequest () {
    var output_type = $( "input[name='outputType']:checked" ).val(),
      report_type = $( "input[name='report']:checked" ).val(),
      query = location.search.substr(1);
    if ( report_type === 'comparative' ) {
      query = query.replace(/report_type%5D=(raw|net_gross)/, 
        "report_type%5D=comptab");
    } else {
      query = query.replace(/report_type%5D=(raw|comptab)/, 
        "report_type%5D=net_gross");
      growlMe("Not implemented yet! Coming soon!");
      return; // TODO
    }
      
    if (output_type === 'web') {
      goToResults(query);
      return;
    } else {
      downloadResults( decodeURIComponent( query ) );
      return
    }
  }

  if (is_download_page) {
    var net_gross_options = $( '#gross_net_section' );
    net_gross_options.hide();
    $( "input[name='outputType']").click( function () {
      if ($(this).val() === 'csv') {
        net_gross_options.show();
      } else {
        net_gross_options.hide();
        $( "#report_comparative").attr("checked", "checked");
      }
    });
  }

  $('#button_report').click( function (e) {handleDownloadRequest() });

  //////////////////////////////
  // View results page specific:

  // This locks-unLock rubbish is used to guarantee that, when populating the
  // results tables, all the ajax calls for the drop-down menus (that also 
  // populate our data objects) are terminated!
  var locks = {
    'initUnitsObj': true, 
    'initCountriesObj': true, 
    'initTermsObj': true, 
    'initPurposesObj': true, 
    'initSourcesObj': true
  };
  function unLock (function_name) {
    var l, query;
    if ( locks[function_name] ) {
      locks[function_name] = false;
    }
    l = _.find(locks, function (value, key) {
      return value === true;
    });
    if (!l && is_view_results_page) {
      // It is time to show these tables!
      query = decodeURIComponent( location.search.substr(1) );
      displayResults(query);
    }
  }

});