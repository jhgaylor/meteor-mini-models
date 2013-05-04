class @MiniModel
  # CLASS METHODS
  @collection: ->
    @_collection ||= eval(@collectionName)
  
  @hasErrors: (field, uuid) ->
    @getErrors(field, uuid) && @getErrors(field, uuid).length > 0
  
  @getErrors: (field, uuid) ->
    allErrors = Session.get("#{@collectionName}:errors:#{uuid}") || {}
    return allErrors[field] if field
    allErrors 
  
  @setErrors: (errors, uuid) ->
    errors ||= {}
    Session.set("#{@collectionName}:errors:#{uuid}", errors)
  
  
  # OBJECT METHODS
  constructor: (doc) ->
    _.extend this, doc
  
  isValid: ->
    @setErrors({})
    _.each @__proto__.constructor.validations, (validationRule) =>
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
    @__proto__.constructor.hasErrors(field, @_id)
    
  getErrors: (field) ->
    @__proto__.constructor.getErrors(field, @_id)
    
  setErrors: (errors) ->
    @__proto__.constructor.setErrors(errors, @_id)
    
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
      @__proto__.constructor.collection().update @_id, data
    else
      @__proto__.constructor.collection().insert data

  destroy: ->
    @__proto__.constructor.collection().remove @_id