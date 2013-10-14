Trade.SandboxShipmentsTable = Ember.Namespace.create()
Trade.SandboxShipmentsTable.EditableTableCell = Ember.Table.TableCell.extend
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

  onCellContentDidChange: Ember.observer ->
    @set('rowContent._modified', true) if @get('isEditing')
  , 'cellContent'

  click: (event) ->
    @set 'isEditing', yes
    event.stopPropagation()

Trade.SandboxShipmentsTable.CheckboxTableCell = Ember.Table.TableCell.extend
  classNames: 'checkbox-table-cell'
  templateName: 'trade/editable-table/checkbox-table-cell'
  isEditing:  no
  type:       'checkbox'

  innerCheckbox: Ember.Checkbox.extend
    typeBinding:  'parentView.type'
    checkedBinding: 'parentView.cellContent'
    didInsertElement: -> @$().focus()
    blur: (event) ->
      @set 'parentView.isEditing', no

  onRowContentDidChange: Ember.observer ->
    @set 'isEditing', no
  , 'rowContent'

  click: (event) ->
    @set 'isEditing', yes
    event.stopPropagation()

Trade.SandboxShipmentsTable.TableRow = Ember.Table.TableRow.extend
  classNameBindings: ['modified']
  modified: Ember.computed ->
    @get('row._modified')
  .property('row._modified')

Trade.SandboxShipmentsTable.TablesContainer =
Ember.Table.TablesContainer.extend Ember.Table.RowSelectionMixin

Trade.SandboxShipmentsTable.TableController = Ember.Table.TableController.extend
  hasHeader: yes
  hasFooter: no
  numFixedColumns: 0
  numRows: 100
  rowHeight: 30
  contentBinding: 'annualReportUploadController.visibleShipments'
  selection: null
  fluidTable: yes
  tableRowViewClass: "Trade.SandboxShipmentsTable.TableRow"

  columnNames: [
      'appendix', 'speciesName', 'termCode', 'quantity', 'unitCode',
      'tradingPartner', 'countryOfOrigin', 'importPermit', 'exportPermit',
      'originPermit', 'purposeCode', 'sourceCode', 'year'
    ]

  columns: Ember.computed ->
    columnProperties =
      appendix:
        width: '4%'
        header: 'Appdx'
      speciesName:
        width: '15%'
        header: 'Species Name'
      termCode:
        width: '5%'
        header: 'Term'
      quantity:
        width: '6%'
        header: 'Qty'
      unitCode:
        width: '4%'
        header: 'Unit'
      tradingPartner:
        width: '5%'
        header: 'Trading partner'
      countryOfOrigin:
        width: '5%'
        header: 'Ctry of Origin'
      importPermit:
        width: '13%'
        header: 'Import Permit'
      exportPermit:
        width: '13%'
        header: 'Export Permit'
      originPermit:
        width: '13%'
        header: 'Origin Permit'
      purposeCode:
        width: '4%'
        header: 'Purpose'
      sourceCode:
        width: '4%'
        header: 'Source'
      year:
        width: '5%'
        header: 'Year'

    columns = @get('columnNames').map (key, index) ->
      Ember.Table.ColumnDefinition.create
        columnWidth: columnProperties[key]['width'] || 100
        headerCellName: columnProperties[key]['header']
        tableCellViewClass: 'Trade.SandboxShipmentsTable.EditableTableCell'
        getCellContent: (row) -> row.get(key)
        setCellContent: (row, value) -> row.set(key, value)
    deleteColumn = Ember.Table.ColumnDefinition.create
      columnWidth: '4%'
      headerCellName: 'Del'
      tableCellViewClass: 'Trade.SandboxShipmentsTable.CheckboxTableCell'
      getCellContent: (row) -> row.get('_destroyed')
      setCellContent: (row, value) ->
        row.set('_destroyed', value)
    columns.push deleteColumn
    columns
  .property()
