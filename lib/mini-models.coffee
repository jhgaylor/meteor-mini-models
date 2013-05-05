class @MiniModel
  # CLASS METHODS
  @collection: ->
    @_collection ||= eval(@collectionName)
  
  @hasErrors: (uuid, field) ->
    !_.isEmpty @getErrors(uuid, field)
  
  @getErrors: (uuid, field) ->
    allErrors = Session.get("#{@collectionName}:errors:#{uuid}") || {}
    return allErrors[field] || [] if field
    allErrors 
  
  @setErrors: (uuid, errors) ->
    errors ||= {}
    Session.set("#{@collectionName}:errors:#{uuid}", errors)
  
  
  # OBJECT METHODS
  constructor: (doc) ->
    _.extend this, doc
  
  isValid: ->
    @setErrors({})
    _.each @__proto__.constructor.validations, (validationRule) =>
      _.each validationRule, (validation, field) =>
        @[field] ||= null
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
    @__proto__.constructor.hasErrors(@_id, field)
    
  getErrors: (field) ->
    @__proto__.constructor.getErrors(@_id, field)
    
  setErrors: (errors) ->
    @__proto__.constructor.setErrors(@_id, errors)
    
  addError: (field, message) ->
    errors = @getErrors()
    errors[field] ||= []
    errors[field].push message
    @setErrors(errors)
    
  notEmpty: (fieldValue) ->
    return false  if _.isEmpty(fieldValue)
    true
    
  maxLength: (fieldValue, length) ->
    return false  unless _.isString fieldValue
    return false  if fieldValue.length > length
    true
    
  minLength: (fieldValue, length) ->
    return false  unless _.isString fieldValue
    return false  if fieldValue.length < length
    true
    
  save: ->
    return false  unless @isValid()
    
    data = _.extend({}, @)
    if data._id
      delete data._id
      @__proto__.constructor.collection().update @_id, data
    else
      @_id = @__proto__.constructor.collection().insert data

  destroy: ->
    @__proto__.constructor.collection().remove @_id