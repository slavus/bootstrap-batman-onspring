class TasksApp extends Batman.App
  @global yes

  @requirePath: '/js/'

  # setup our root route. When the app starts up, it will automatically call TodosController::index
  @root 'tasks#index'

  @on 'run', ->
    @set('mytasks', TasksApp.Task.get('all'))

    #Jquery stuff comes here
    $(document).ready ->
      #acivate bootstrap collapsable
      $(".nav-collapse").collapse()
      $("#aaa").click ->
        $(".nav-collapse").collapse('toggle')

class TasksApp.RestStorage extends Batman.RestStorage
  serializeAsForm: false

  #this will generate json model like {"id":1,"description":"desc" ,"done":true} 
  # insted {"task": {"id":1,"description":"desc" ,"done":true}}
  recordJsonNamespace: ->
      false


# --------------- MODELS ---------------------------------

class TasksApp.Task extends Batman.Model

  @global yes
  @persist TasksApp.RestStorage
  @url = "/api/v1/tasks"
  @encode  'id', 'description', 'done'
  #@validate 'description',  presence: yes, lengthWithin: [6,255]


# class TasksApp.TaskPaginator extends Batman.ModelPaginator
#   model: Tazks.Task
#   limit: 25
#   totalTasks: 100
#   # Optionally override paramsForOffsetAndLimit(offset, limit) to define
#   # what params to send to the server



# --------------- Controllers ---------------------------------
class TasksApp.TasksController extends Batman.Controller
  constructor: ->
    super
    # setup a binding for the new form
    @set 'newTask', new Task
    @set 'errorMsg', ""

  index: ->
    # prevent the implicit render of views/todos/index.html
    console.log "App init"
    @render false

  create: -> 
    @newTask.save (err) =>
      if err
        @handleError(err)
      else
       @set 'newTask', new Task
  
  taskDoneChanged:(node, event, context) ->
    task = context.get('task')
    task.save (err) =>
      @handleError(err) if err

  deleteTask:(node, event, context) ->
    task = context.get('task')
    task.destroy()
    console.log( "obrisano")
  
  handleError: (err) ->
    @set 'errorMsg', JSON.parse(err.responseText).content if err
    @unset 'errorMsg' if  not err
    console.log(JSON.parse(err.responseText).content) if err 
  

window.TasksApp = TasksApp
TasksApp.run()