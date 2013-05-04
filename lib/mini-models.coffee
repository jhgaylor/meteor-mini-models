class @MiniModel
  errors: {}
  constructor: (doc, collectionName, validations) ->
    self = this
    _.extend self, doc, {
      _collectionName: collectionName || "", 
      _validations:    validations || []
    }
    
  collection: ->
    self = this
    self._collection ||= eval(self._collectionName)
    self._collection
  
  isValid: ->
    self = this
    self.resetErrors()
    _.each self._validations, (validationRule) ->
      _.each validationRule, (validation, field) ->
        rule = validation.rule || validation
        message = validation.message
        
        # {title: 'notEmpty'}
        if _.isString(rule) and _.isFunction(self[rule])
          message = field + " " + rule  unless message
          self.addError field, message  unless self[rule](self[field])
      
        # {title: ['minLength', 5]}
        else if _.isArray(rule) and self[rule[0]]
          message = field + " " + rule[0] + " " + rule[1]  unless message
          self.addError field, message  unless self[rule[0]](self[field], rule[1])
      
        # rule defined as function
        else if _.isFunction(rule)
          message = field + " error"  unless message
          self.addError field, message  unless rule(self[field])
          
    true  if _.isEmpty(self.errors)
    
  resetErrors: ->
    self = this
    self.errors = {}
  addError: (field, message) ->
    self = this
    self.errors[field] ||= []
    self.errors[field].push message
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
    self = this
    return false  unless self.isValid()
    
    data = _.extend({}, self)
    if data._id
      delete data._id
      self.collection().update self._id, data
    else
      self.collection().insert data

  destroy: ->
    self = this
    self.collection().remove self._id