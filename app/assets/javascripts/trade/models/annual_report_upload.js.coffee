Trade.AnnualReportUpload = DS.Model.extend
  numberOfRows: DS.attr('number')
  createdAt: DS.attr('date')
  updatedAt: DS.attr('date')
  # TODO created_by
  # TODO updated_by
  sandboxShipments: DS.hasMany('Trade.SandboxShipment')
  validationErrors: DS.hasMany('Trade.ValidationError')

Trade.Adapter.map('Trade.AnnualReportUpload', {
  sandboxShipments: { embedded: 'always' }
  validationErrors: { embedded: 'load' }
})
