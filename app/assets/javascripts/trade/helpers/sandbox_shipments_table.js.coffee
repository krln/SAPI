Trade.SandboxShipmentsTable = Ember.Namespace.create()
Trade.SandboxShipmentsTable.EditableTableCell = Ember.Table.TableCell.extend
  classNames: 'editable-table-cell'
  templateName: 'editable-table-cell'
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

Trade.SandboxShipmentsTable.DatePickerTableCell =
Trade.SandboxShipmentsTable.EditableTableCell.extend
  type: 'date'

Trade.SandboxShipmentsTable.RatingTableCell = Ember.Table.TableCell.extend
  classNames: 'rating-table-cell'
  templateName: 'rating-table-cell'
  didInsertElement: ->
    @_super()
    @onRowContentDidChange()
  applyRating: (rating) ->
    @$('.rating span').removeClass('active')
    span   = @$('.rating span').get(rating)
    $(span).addClass('active')
  click: (event) ->
    rating = @$('.rating span').index(event.target)
    return if rating is -1
    @get('column').setCellContent(@get('rowContent'), rating)
    @applyRating(rating)
  onRowContentDidChange: Ember.observer ->
    @applyRating @get('cellContent')
  , 'cellContent'

Trade.SandboxShipmentsTable.TablesContainer =
Ember.Table.TablesContainer.extend Ember.Table.RowSelectionMixin

Trade.SandboxShipmentsTable.TableController = Ember.Table.TableController.extend
  hasHeader: yes
  hasFooter: no
  numFixedColumns: 0
  numRows: 100
  rowHeight: 30
  selection: null

  columns: Ember.computed ->
    columnNames = ['open', 'close']
    dateColumn = Ember.Table.ColumnDefinition.create
      columnWidth: 100
      headerCellName: 'Date'
      tableCellViewClass: 'Trade.SandboxShipmentsTable.DatePickerTableCell'
      getCellContent: (row) -> row['date'].toString('yyyy-MM-dd')
      setCellContent: (row, value) -> row['date'] = value
    ratingColumn = Ember.Table.ColumnDefinition.create
      columnWidth: 150
      headerCellName: 'Analyst Rating'
      tableCellViewClass: 'Trade.SandboxShipmentsTable.RatingTableCell'
      contentPath: 'rating'
      setCellContent: (row, value) -> row['rating'] = value
    columns= columnNames.map (key, index) ->
      name = key.charAt(0).toUpperCase() + key.slice(1)
      Ember.Table.ColumnDefinition.create
        columnWidth: 100
        headerCellName: name
        tableCellViewClass: 'Trade.SandboxShipmentsTable.EditableTableCell'
        getCellContent: (row) -> row[key].toFixed(2)
        setCellContent: (row, value) -> row[key] = +value
    columns.unshift(ratingColumn)
    columns.unshift(dateColumn)
    columns
  .property()

  content: Ember.computed ->
    [0...@get('numRows')].map (num, idx) ->
      index: idx
      date:  Date.today().add(days: idx)
      open:  Math.random() * 100 - 50
      close: Math.random() * 100 - 50
      rating:Math.round(Math.random() * 4)
  .property 'numRows'