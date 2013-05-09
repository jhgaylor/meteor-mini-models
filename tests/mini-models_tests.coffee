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
      rule: (fieldValue) ->
        return false  unless _.isString fieldValue
        return false  if _.indexOf(fieldValue, ".") == -1
        return true;
      message:  'Title must contain "."'
    }
  ]
  
@Todos = new Meteor.Collection "todos",
  transform: (doc) ->
    new Todo doc
    
cleanupTodos = ->
  _.each Todos.find().fetch(), (todo) ->
    Todos.remove todo._id

withCleanup = (fn) ->
  return ->
    res = fn.apply(this, arguments);
    
    cleanupTodos()
    Meteor.flush()
    return res

Tinytest.add 'model.notEmpty', withCleanup (test) -> 
  model = new MiniModel
  test.isTrue model.notEmpty "something"
  test.isFalse model.notEmpty ""

Tinytest.add 'model.minLength', withCleanup (test) -> 
  model = new MiniModel
  test.isTrue model.minLength "something", 5
  test.isFalse model.minLength "something", 10

Tinytest.add 'model.maxLength', withCleanup (test) -> 
  model = new MiniModel
  test.isTrue model.maxLength "something", 10
  test.isFalse model.maxLength "something", 5
  
Tinytest.add 'model.isValid', withCleanup (test) -> 
  todo = new Todo
  test.isFalse todo.isValid()
  todo.title = "A new title"
  test.isFalse todo.isValid()
  todo.title += "."
  test.isTrue todo.isValid()

Tinytest.add 'model.hasErrors', withCleanup (test) -> 
  todo = new Todo
  todo.isValid()
  test.isTrue todo.hasErrors()
  test.isTrue todo.hasErrors("title")

Tinytest.add 'model.getErrors', withCleanup (test) -> 
  todo = new Todo
  todo.isValid()
  test.isFalse _.isEmpty todo.getErrors().title
  test.equal todo.getErrors("title").length, 4
  
Tinytest.add 'model.save', withCleanup (test) ->
  test.isUndefined Todos.findOne()
  todo = new Todo {title: null}
  todo.save()
  test.isUndefined Todos.findOne()
  todo.title = "This is the new title."
  todo.save()
  test.equal Todos.findOne().title, todo.title
  test.equal Todos.findOne()._id, todo._id
  
Tinytest.add 'model.destroy', withCleanup (test) ->
  test.isUndefined Todos.findOne()
  todo = new Todo {title: "This is the title."}
  todo.save()
  test.equal Todos.findOne().title, todo.title
  test.equal Todos.findOne()._id, todo._id
  todo.destroy()
  test.isUndefined Todos.findOne()
  
Tinytest.add 'ModelClass.hasErrors', withCleanup (test) -> 
  todo = new Todo
  todo.isValid()
  test.isTrue Todo.hasErrors()
  test.isTrue Todo.hasErrors("title")
  
Tinytest.add 'ModelClass.getErrors', withCleanup (test) -> 
  todo = new Todo
  todo.isValid()
  test.isFalse _.isEmpty Todo.getErrors().title
  test.equal Todo.getErrors("title").length, 4
