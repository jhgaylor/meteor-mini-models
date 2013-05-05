meteor-mini-models
==================

Simple models for meteor inspired by [http://www.eventedmind.com/posts/meteor-transforming-collection-documents] (http://www.eventedmind.com/posts/meteor-transforming-collection-documents "http://www.eventedmind.com/posts/meteor-transforming-collection-documents")

Latest version: **0.1.0**

## Install
To install in a new project:

    > mrt add mini-models

To update an existing project:

    > mrt update mini-models

## Run tests

    > git clone https://github.com/EmmN/meteor-mini-models.git mini-models
    > cd mini-models
    > mrt test-packages ../mini-models

## Defining models
### Coffeescript:
Model Definition:

    class @Todo extends MiniModel
      @collectionName: "Todos"
      @validations: [
        {title: 'notEmpty'},
        {title: ['minLength', 5]},
        {title: 
          rule:     ['maxLength', 50]
          message:  'Title can not be longer than 50 chars'
        },
        {title:
          rule: (field) ->
            return false if _.indexOf(field, ".") == -1
            return true;
          message:  'Title must contain "."'
        }
      ]

Collection definition:

    @Todos = new Meteor.Collection "todos",
      transform: (doc) ->
        new Todo doc

### Javascript:
Model definition:

    var __hasProp = {}.hasOwnProperty,
      __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };
    
    this.Todo = (function(_super) {
    
      __extends(Todo, _super);
    
      function Todo() {
        return Todo.__super__.constructor.apply(this, arguments);
      }
    
      Todo.collectionName = "Todos";
    
      Todo.validations = [
        {
          title: 'notEmpty'
        }, {
          title: ['minLength', 5]
        }, {
          title: {
            rule: ['maxLength', 50],
            message: 'Title can not be longer than 50 chars'
          }
        }, {
          title: {
            rule: function(field) {
              if (_.indexOf(field, ".") === -1) {
                return false;
              }
              return true;
            },
            message: 'Title must contain "."'
          }
        }
      ];
    
      return Todo;
    
    })(MiniModel);

Collection definition:

    this.Todos = new Meteor.Collection("todos", {
      transform: function(doc) {
        return new Todo(doc);
      }
    });

## Model Methods

- **save** - save model data
- **destroy** - delete model from collection
- **hasErrors** - returns if there were any errors during a save. (in case field is provided it checks errors only for that field)
- **getErrors** - returns all the errors that appeared during a save. (in case field is provided returns only the errors for that specific field)

## Validations
See sample app for examples on how to use different types of validations. Fields can be validated using one of the predefined validation methods or by writing your own validation methods.

All validation errors are saved in Session so we can take advantage of Meteor's reactivity.

Predefined validation methods:

- **notEmpty**
- **maxLength**
- **minLength**

## Demo sample app
[https://github.com/EmmN/meteor-mini-models-sample-app] (https://github.com/EmmN/meteor-mini-models-sample-app "https://github.com/EmmN/meteor-mini-models-sample-app")
