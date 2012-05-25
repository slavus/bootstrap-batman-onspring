helpers = if typeof require is 'undefined' then window.viewHelpers else require './view_helper'

oldRequest = Batman.Request
class MockRequest extends MockClass
  @chainedCallback 'success'
  @chainedCallback 'error'
count = 0

QUnit.module 'Batman.View'
  setup: ->
    MockRequest.reset()
    @options =
      source: "test_path#{++count}"

    Batman.Request = MockRequest
    @view = new Batman.View(@options) # create a view which uses the MockRequest internally

  teardown: ->
    Batman.Request = oldRequest

test 'should pull in the source for a view from a path', 1, ->
  equal MockRequest.lastConstructorArguments[0].url, "/views/#{@options.source}.html"

test 'should update its node with the contents of its view', 1, ->
  MockRequest.lastInstance.fireSuccess('view contents')
  equal @view.get('node').innerHTML, 'view contents'

test 'should not add its node property as a source to an enclosing accessor', 1, ->
  class TestView extends Batman.View
    render: spy = createSpy().whichReturns(true)

  accessible = new Batman.Accessible -> new TestView()
  view = accessible.get()
  view.set('node', {})
  newView = accessible.get()
  equal newView, view

test 'should update a new, set node with the contents of its view after the source loads', 1, ->
  node = document.createElement('div')
  @view.set('node', node)
  MockRequest.lastInstance.fireSuccess('view contents')
  equal node.innerHTML, 'view contents'

test 'should update a new, set node node with the contents of its view if the node is set after the source loads', 1, ->
  node = document.createElement('div')
  MockRequest.lastInstance.fireSuccess('view contents')
  @view.set('node', node)
  equal node.innerHTML, 'view contents'

asyncTest 'should fire the ready event once its contents have been loaded', 1, ->
  @view.on 'ready', observer = createSpy()

  MockRequest.lastInstance.fireSuccess('view contents')
  delay =>
    ok observer.called

asyncTest 'should allow prefetching of view sources', 2, ->
  Batman.View.store.prefetch('view')
  equal MockRequest.lastConstructorArguments[0].url, "/views/view.html"
  delay =>
    MockRequest.lastInstance.fireSuccess('prefetched contents')
    view = new Batman.View({source: 'view'})
    equal view.get('html'), 'prefetched contents'
