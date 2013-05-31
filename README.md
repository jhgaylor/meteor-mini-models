meteor-mini-models
==================

Simple models for meteor inspired by [http://www.eventedmind.com/posts/meteor-transforming-collection-documents] (http://www.eventedmind.com/posts/meteor-transforming-collection-documents "http://www.eventedmind.com/posts/meteor-transforming-collection-documents")

Latest version: **0.1.2**

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
      @beforeSave: [
        (todo) ->
          todo.beforeData = "before"
        (todo) ->
          todo.beforeData2 = "before2"
      ]
      @afterSave: [
        (todo) ->
          todo.afterData = "after"
      ]


Collection definition:

    @Todos = new Meteor.Collection "todos",
      transform: (doc) ->
        new Todo doc

### Javascript:
[http://js2coffee.org/] (http://js2coffee.org/ "http://js2coffee.org/") can be used to convert the coffeescript code to javascript code.

## Model Methods

- **save** - save model data
- **destroy** - delete model from collection
- **hasErrors** - returns if there were any errors during a save. (in case field is provided it checks errors only for that field)
- **getErrors** - returns all the errors that appeared during a save. (in case field is provided returns only the errors for that specific field)

## Model Callbacks

- **beforeSave** - callback run before saving a model
- **afterSave** - callback run after saving a model
- **beforeDestroy** - callback run before destroying a model
- **afterDestroy** - callback run after destroying a model

## Validations
See sample app for examples on how to use different types of validations. Fields can be validated using one of the predefined validation methods or by writing your own validation methods.

All validation errors are saved in Session so we can take advantage of Meteor's reactivity.

Predefined validation methods:

- **notEmpty**
- **maxLength**
- **minLength**

## Demo sample app
[https://github.com/EmmN/meteor-mini-models-sample-app] (https://github.com/EmmN/meteor-mini-models-sample-app "https://github.com/EmmN/meteor-mini-models-sample-app")
