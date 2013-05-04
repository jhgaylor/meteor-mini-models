this.MiniModel = (function() {

  function MiniModel(doc, collectionName) {
    _.extend(this, doc, {
      _collectionName: collectionName
    });
  }
  
  MiniModel.prototype = {
    constructor:  MiniModel,
    errors:       {},
    
    collection: function() {
      var self = this;
      self._collection || (self._collection = eval(self._collectionName));
      return self._collection;
    },
    
    validations: function() {
      return []
    },
    
    // validations = function() { return [
    //   { title: 'notEmpty' },
    //   { title: {
    //       rule:     ['maxLength', 50],
    //       message:  'Title can not be longer than 50 chars'
    //     }
    //   },
    //   { title: {
    //       rule: function(field) { 
    //         if (!_.indexOf(field, ".")) return false;
    //         return true;
    //       },
    //       message: 'Title must contain "."'
    //     } 
    //   }
    // ]}
    isValid: function() {
      var self = this;
      
      console.log(self)
      
      _.each(self.validations(), function(validationRule) {
        _.each(validationRule, function(field, validation) {
          var rule = validation.rule;
          var message = validation.message;
          if (!rule) rule = validation;
          
          // {title: 'notEmpty'}
          if (_.isString(rule) && self[rule] ) {
            if (!message) message = field + " " + rule;
            if (! self[rule]()) self.addError(field, message);
          
          // {title: ['minLength', 5]}
          } else if (_.isArray(rule) && self[rule[0]] ) {
            if (!message) message = field + " " + rule[0] + " " + rule[1];
            if (! self[rule[0]](rule[1])) self.addError(field, message);
            
          //   { title: function(field) { 
          //      if (!_.indexOf(field, ".")) return false;
          //       return true;
          //     },
          //     message: 'Title must contain "."'
          //   } 
          } else if (_.isFunction(rule)) {
            if (!message) message = field + " error";
            if (! rule(self[field])) self.addError(field, message);
          }
        })
      })
      
      if (_.isEmpty(self.errors)) return true;
    },
    
    addError: function(field, message) {
      var self = this;
      self.errors = self.errors || {};
      self.errors[field] = self.errors[field] || [];
      self.errors[field].push(message);
    },
    
    notEmpty: function(field) { 
      if (_.isEmpty(field)) return false;
      return true;
    },
    
    maxLength: function(field, length) { 
      if ((field.length > length)) return false;
      return true;
    },
    
    minLength: function(field, length) { 
      if ((field.length < length)) return false;
      return true;
    },
    
    // save
    save: function() {
      var self = this;
      var data;
      data = _.extend({}, self);
      
      if (!self.isValid()) return false;
      
      if (data._id) {
        delete data._id;
        return self.collection().update(self._id, data);
      } else {
        return self.collection().insert(data);
      }
    },
    
    // delete
    delete: function() {
      var self = this;
      return self.collection().remove(self._id);
    }
  }

  return MiniModel;

})();
