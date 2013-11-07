Trade.ShipmentsTable = Ember.Namespace.create()
Trade.ShipmentsTable.EditableTableCell = Ember.Table.TableCell.extend
  classNames: 'editable-table-cell'
  templateName: 'trade/editable-table/editable-table-cell'
  isEditing:  no
  type:       'text'

  innerTextField: Ember.TextField.extend
    typeBinding:  'parentView.type'
    valueBinding: 'parentView.cellContent'
    didInsertElement: -> @$().focus()
    blur: (event) ->
      @set 'parentView.isEditing', no

  onRowContentDidChange: Ember.observer ->
    @set 'isEditing', no
  , 'rowContent'

  click: (event) ->
    @set 'isEditing', yes
    event.stopPropagation()

Trade.ShipmentsTable.CheckboxTableCell = Ember.Table.TableCell.extend
  classNames: 'checkbox-table-cell'
  templateName: 'trade/editable-table/checkbox-table-cell'
  isEditing:  no
  type:       'checkbox'

  innerCheckbox: Ember.Checkbox.extend
    typeBinding:  'parentView.type'
    checkedBinding: 'parentView.cellContent'
    blur: (event) ->
      @set 'parentView.isEditing', no

  onRowContentDidChange: Ember.observer ->
    @set 'isEditing', no
  , 'rowContent'

  click: (event) ->
    @set 'isEditing', yes
    event.stopPropagation()

Trade.ShipmentsTable.TablesContainer =
Ember.Table.TablesContainer.extend Ember.Table.RowSelectionMixin

Trade.ShipmentsTable.TableController = Ember.Table.TableController.extend
  hasHeader: yes
  hasFooter: no
  numFixedColumns: 0
  numRows: 100
  rowHeight: 30
  shipments: null
  selection: null

  columns: Ember.computed ->
    columnNames = [
      'appendix', 'reportedAppendix', 'speciesName', 'reportedSpeciesName',
      'termCode', 'quantity', 'unitCode', 'importer', 'exporter',
      'reporterType', 'countryOfOrigin', 'purposeCode', 'sourceCode',
      'year', 'importPermit', 'exportPermit', 'originPermit'
    ]
    columnProperties =
      appendix:
        width: 45
        header: 'Appdx'
      reportedAppendix:
        width: 55
        header: 'Rep. Appdx'
      speciesName:
        width: 200
        header: 'Species'
      reportedSpeciesName:
        width:200
        header: 'Rep. Species'
      termCode:
        width: 50
        header: 'Term'
      quantity:
        width: 50
        header: 'Qty'
      unitCode:
        width: 50
        header: 'Unit'
      importer:
        width: 100
        header: 'Importer'
      exporter:
        width: 100
        header: 'Exporter'
      reporterType:
        width: 50
        header: 'Reporter Type'
      countryOfOrigin:
        width: 100
        header: 'Ctry of Origin'
      purposeCode:
        width: 50
        header: 'Purpose'
      sourceCode:
        width: 50
        header: 'Source'
      year:
        width: 40
        header: 'Year'
      importPermit:
        width: 150
        header: 'Import Permit'
      exportPermit:
        width: 150
        header: 'Export Permit'
      originPermit:
        width: 150
        header: 'Origin Permit'

    columns = columnNames.map (key, index) ->
      Ember.Table.ColumnDefinition.create
        columnWidth: columnProperties[key]['width'] || 100
        headerCellName: columnProperties[key]['header']
        tableCellViewClass: 'Trade.ShipmentsTable.EditableTableCell'
        getCellContent: (row) -> row.get(key)
        setCellContent: (row, value) -> row.set(key, value)
    deleteColumn = Ember.Table.ColumnDefinition.create
      columnWidth: 50
      headerCellName: 'Delete'
      tableCellViewClass: 'Trade.ShipmentsTable.CheckboxTableCell'
      getCellContent: (row) -> row.get('_destroyed')
      setCellContent: (row, value) -> 
        row.set('_destroyed', value)
    columns.unshift deleteColumn
    columns
  .property()

  content: Ember.computed ->
    @get('shipments')
  .property 'shipments'

