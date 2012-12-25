google.load('jquery', '1');

onLoad = ->
  $.log = ->
    if window.console
      console.log.apply(console, arguments)

  Game.init() if $('body').is('.games.show')

google.setOnLoadCallback ->
  try
    $ onLoad
  catch e
    $.log(e)

Console =
  elem: ->
    $("#console")
  log: (a...) ->

window.Game =
  list: {}
  console: Console

  field: ->
    $("#space")

  name: ->
    window.location.href.split('/').pop()

  init: ->
    console.log @list, @name()
    @list[@name()].start(@field)
