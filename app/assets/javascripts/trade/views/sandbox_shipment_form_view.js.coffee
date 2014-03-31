Trade.SandboxShipmentForm = Ember.View.extend
  classNames: ['modal hide fade shipment-form-modal']
  layoutName: 'trade/sandbox_shipment_form'
  content: null

  didInsertElement: ->
    @.$().on('hidden', () =>
      @set('controller.currentShipment', null)
    )
