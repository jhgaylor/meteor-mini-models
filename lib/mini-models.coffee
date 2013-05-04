class @MiniModel
  constructor: (doc, collectionName, validations) ->
    _.extend this, doc, {
      _collectionName: collectionName || "", 
      _validations:    validations || [],
      _sessionUUID:    doc._id || Meteor.uuid()
    }
    
  collection: ->
    @_collection ||= eval(@_collectionName)
  
  isValid: ->
    @setErrors({})
    _.each @_validations, (validationRule) =>
      _.each validationRule, (validation, field) =>
        rule = validation.rule || validation
        message = validation.message
        
        # {title: 'notEmpty'}
        if _.isString(rule) and _.isFunction(@[rule])
          message = field + " " + rule  unless message
          @addError field, message  unless @[rule](@[field])
      
        # {title: ['minLength', 5]}
        else if _.isArray(rule) and @[rule[0]]
          message = field + " " + rule[0] + " " + rule[1]  unless message
          @addError field, message  unless @[rule[0]](@[field], rule[1])
      
        # rule defined as function
        else if _.isFunction(rule)
          message = field + " error"  unless message
          @addError field, message  unless rule(@[field])
          
    return true  if _.isEmpty(@getErrors())
    false
    
  hasErrors: (field) ->
    @getErrors(field) && @getErrors(field).length > 0
  getErrors: (field)->
    allErrors = Session.get("errors_#{@_sessionUUID}") || {}
    return allErrors[field] if field
    allErrors 
  setErrors: (errors)->
    errors ||= {}
    Session.set("errors_#{@_sessionUUID}", errors)
  addError: (field, message) ->
    errors = @getErrors()
    errors[field] ||= []
    errors[field].push message
    @setErrors(errors)
  notEmpty: (field) ->
    return false  if _.isEmpty(field)
    true
  maxLength: (field, length) ->
    return false  if field.length > length
    true
  minLength: (field, length) ->
    return false  if field.length < length
    true
    
  save: ->
    return false  unless @isValid()
    
    data = _.extend({}, @)
    if data._id
      delete data._id
      @collection().update @_id, data
    else
      @collection().insert data

  destroy: ->
    @collection().remove @_id